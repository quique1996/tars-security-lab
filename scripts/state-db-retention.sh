#!/usr/bin/env bash
# state.db retention policy — TARS
# state.db es DATOS REALES (sesiones, memoria FTS5). NO purgar.
# Esta política: checkpoint WAL + VACUUM periódico + límite de snapshots.
set -euo pipefail

DB="$HOME/.hermes/state.db"
SNAPSHOT_DIR="$HOME/.hermes/state-snapshots"
MAX_SNAPSHOTS=5
MIN_SIZE_MB=200

echo "[$(date +%Y-%m-%dT%H:%M:%S)] state.db retention"

if [ ! -f "$DB" ]; then
  echo "DB not found: $DB"; exit 0
fi

size_mb=$(du -m "$DB" | cut -f1)
echo "current size: ${size_mb}MB"

# 1. WAL checkpoint (seguro, no destructivo)
sqlite3 "$DB" "PRAGMA wal_checkpoint(TRUNCATE);" 2>/dev/null || echo "checkpoint failed (gateway lock?) — skip"

# 2. VACUUM si supera umbral (libera freelist, preserva datos)
if [ "$size_mb" -gt "$MIN_SIZE_MB" ]; then
  echo "vacuuming (may take a moment)..."
  sqlite3 "$DB" "VACUUM;" 2>/dev/null || echo "vacuum failed — safe, DB untouched"
fi

# 3. Snapshots: mantener solo los últimos MAX_SNAPSHOTS
if [ -d "$SNAPSHOT_DIR" ]; then
  ls -1dt "$SNAPSHOT_DIR"/* 2>/dev/null | tail -n +$((MAX_SNAPSHOTS + 1)) | while read -r old; do
    echo "removing old snapshot: $old"
    rm -rf "$old"
  done
fi

echo "[done] size now: $(du -m "$DB" | cut -f1)MB"
