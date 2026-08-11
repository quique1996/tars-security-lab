#!/usr/bin/env bash
# portswigger-sync.sh — Sync GEEKOM /opt/portswigger -> repo tars-security-lab (Air)
#
# The canonical workflow runs the lab tracker on GEEKOM (/opt/portswigger,
# where Burp + browser live). This script pulls the state files and new
# writeups back to the repo and commits them.
#
# Usage:
#   portswigger-sync.sh            sync + commit + push (if remote set)
#   portswigger-sync.sh --dry-run  show what would change, change nothing
#   portswigger-sync.sh --pull-only  rsync down, no commit
set -euo pipefail

GEEKOM_HOST="${GEEKOM_HOST:-root@geekom}"
GEEKOM_SRC="${GEEKOM_SRC:-/opt/portswigger/}"
REPO_DIR="${REPO_DIR:-$HOME/Projects/tars-security-lab/portswigger}"
SYNC_FILES=(labs.json tracker.md writeups evidence)

DRY_RUN=0
PULL_ONLY=0
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    --pull-only) PULL_ONLY=1 ;;
    *) echo "argumento desconocido: $arg" >&2; exit 2 ;;
  esac
done

RSYNC_ARGS=(-az --delete)
[[ "$DRY_RUN" == 1 ]] && RSYNC_ARGS+=(-n)

echo "== Sync GEEKOM ($GEEKOM_HOST:$GEEKOM_SRC) -> $REPO_DIR =="
for f in "${SYNC_FILES[@]}"; do
  rsync "${RSYNC_ARGS[@]}" "$GEEKOM_HOST:$GEEKOM_SRC$f/" "$REPO_DIR/$f/" 2>/dev/null \
    || rsync "${RSYNC_ARGS[@]}" "$GEEKOM_HOST:$GEEKOM_SRC$f" "$REPO_DIR/$f" \
    || echo "WARN: no existe $f en GEEKOM"
done

[[ "$DRY_RUN" == 1 ]] && { echo "dry-run: nada modificado"; exit 0; }

cd "$REPO_DIR"
if [[ "$PULL_ONLY" == 1 ]]; then
  echo "pull-only: sin commit"
  exit 0
fi

if [[ -z "$(git status --porcelain)" ]]; then
  echo "sin cambios — nada que commitear"
  exit 0
fi

git add -A
git commit -m "portswigger: sync estado labs desde GEEKOM ($(date -u '+%Y-%m-%d %H:%M UTC'))" >/dev/null
echo "commit hecho: $(git rev-parse --short HEAD)"
if git remote get-url origin >/dev/null 2>&1; then
  git push -q origin HEAD && echo "push OK"
else
  echo "sin remote origin — commit local solamente"
fi
