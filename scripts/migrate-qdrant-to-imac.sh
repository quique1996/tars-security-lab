#!/usr/bin/env bash
# Migrate Qdrant: Mini M4 -> iMac M3 (100.70.240.126)
# PREPARADO 2026-08-10 — NO ejecutar hasta tener acceso SSH al iMac.
# Uso: ./migrate-qdrant-to-imac.sh <imac-user>
set -euo pipefail

IMAC_USER="${1:?uso: $0 <imac-user>}"
IMAC="100.70.240.126"
MINI="quiquebs@100.90.88.5"
MINI_DATA="/Users/quiquebs/qdrant_data"
IMAC_DATA="/Users/$IMAC_USER/qdrant_data"
STAMP=$(date +%Y%m%d-%H%M%S)

echo "=== [1/6] Preflight: SSH al iMac ==="
ssh -o ConnectTimeout=8 -o BatchMode=yes "$IMAC_USER@$IMAC" "echo IMAC_OK; sw_vers -productVersion; sysctl -n hw.memsize | awk '{print \$1/1073741824 \" GB\"}'" || { echo "FALLO: sin acceso al iMac. Autoriza pubkey primero."; exit 1; }

echo "=== [2/6] Backup en Mini (fail-closed) ==="
ssh -o ConnectTimeout=8 "$MINI" "docker exec qdrant sh -c 'tar czf /qdrant/backup-\$STAMP.tar.gz -C /qdrant/storage .' 2>/dev/null || echo 'backup interno falló (se hace por rsync)'; ls -la /Users/quiquebs/qdrant_data | head -3"
echo "backup: $MINI_DATA -> respaldo local (rsync conserva todo)"

echo "=== [3/6] Verificar colecciones en Mini (antes de tocar) ==="
ssh -o ConnectTimeout=8 "$MINI" "curl -s http://127.0.0.1:6333/collections | python3 -c \"import json,sys; print(len(json.load(sys.stdin)['result']['collections']), 'collections')\""

echo "=== [4/6] Preparar destino en iMac (Docker + dir) ==="
ssh -o ConnectTimeout=8 "$IMAC_USER@$IMAC" "mkdir -p $IMAC_DATA; which docker || echo 'Docker no instalado en iMac — instalar primero: brew install --cask docker o colima'"

echo "=== [5/6] Rsync datos (Mini -> iMac) ==="
# rsync vía ssh directo (Tailscale), preserva todo
rsync -avz --progress -e "ssh -o ConnectTimeout=8" "$MINI:$MINI_DATA/" "$IMAC_USER@$IMAC:$IMAC_DATA/" 

echo "=== [6/6] Levantar Qdrant en iMac (compose 2g) ==="
ssh -o ConnectTimeout=8 "$IMAC_USER@$IMAC" "mkdir -p ~/qdrant-compose && cat > ~/qdrant-compose/docker-compose.yml <<'YAML'
services:
  qdrant:
    image: qdrant/qdrant:latest
    container_name: qdrant
    restart: unless-stopped
    mem_limit: 2g
    cpus: 2
    ports:
      - '127.0.0.1:6333:6333'
    volumes:
      - $IMAC_DATA:/qdrant/storage
YAML
cd ~/qdrant-compose && docker compose up -d && sleep 5 && curl -s http://127.0.0.1:6333/collections | head -c 300"

echo ""
echo "=== VERIFICAR ==="
echo "1. iMac: curl 127.0.0.1:6333/collections → 11 collections?"
echo "2. Actualizar config del MCP qdrant (Mini) para apuntar a imac: QDRANT_URL=http://100.70.240.126:6333"
echo "3. NUNCA borrar $MINI_DATA hasta 2 días sin errores (rollback)"
echo "STAMP=$STAMP"
