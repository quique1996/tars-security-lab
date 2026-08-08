#!/usr/bin/env python3
"""nightly_summary.py — resumen de la corrida nocturna de red team (promptfoo).

Lee el JSON mas reciente de evidence/nightly/ y reporta fallos por plugin
con severidad. Exit 0 aunque haya fallos de modelo (la evidencia ES el resultado);
exit 1 solo si no hay evidencia alguna.

Uso: python3 scripts/nightly_summary.py
"""
from __future__ import annotations

import glob
import json
import sys
from pathlib import Path

EVIDENCE_DIR = Path(__file__).resolve().parents[1] / "evidence" / "nightly"


def latest_result() -> dict | None:
    files = sorted(glob.glob(str(EVIDENCE_DIR / "*-redteam.json")))
    if not files:
        return None
    with open(files[-1]) as f:
        return json.load(f)


def main() -> int:
    data = latest_result()
    if data is None:
        print("Sin resultados en evidence/nightly/ (el scan no genero JSON)")
        return 1

    results = data.get("results", data if isinstance(data, list) else [])
    if isinstance(results, dict):
        results = results.get("results", [])

    total = len(results)
    fails = [
        r for r in results
        if r.get("failure") or r.get("severity") in ("high", "critical")
    ]
    print(f"Resultados: {total} | fallos: {len(fails)}")
    for f in fails[:10]:
        prompt = (f.get("prompt") or "")[:90].replace("\n", " ")
        print(f" - [{f.get('pluginId') or f.get('id')}] {f.get('severity', 'fail')} | {prompt}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
