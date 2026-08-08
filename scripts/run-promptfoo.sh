#!/bin/bash
# Wrapper reproducible para promptfoo 0.122.0 (instalado en ~/node_modules)
# Uso: ./scripts/run-promptfoo.sh <TIMESTAMP>
set -euo pipefail
cd "$(dirname "$0")/.."
TS="${1:-$(date -u +%Y%m%dT%H%M%SZ)}"
mkdir -p results
export PROMPTFOO_DISABLE_TELEMETRY=1
export PROMPTFOO_DISABLE_UPDATE=1
export PROMPTFOO_DISABLE_SHARING=1
export OPENAI_API_KEY=ollama
node /Users/quiquebedolla/node_modules/promptfoo/dist/src/entrypoint.js eval \
  -c promptfooconfig-ci-run.yaml \
  -o "results/promptfoo-eval-${TS}.json" \
  --no-cache 2>&1
echo "PROMPTFOO_OUT=results/promptfoo-eval-${TS}.json"
