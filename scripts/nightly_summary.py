#!/usr/bin/env python3
"""nightly_summary.py — resumen de la corrida nocturna de red team (promptfoo).

Lee el JSON de resultados mas reciente de evidence/nightly/ (eval-results.json
o -redteam.json) y reporta fallos por test/plugin. Exit 0 aunque haya fallos
de modelo (la evidencia ES el resultado); exit 1 solo si no hay evidencia.

Uso: python3 scripts/nightly_summary.py
"""
from __future__ import annotations

import glob
import json
import sys
from pathlib import Path

EVIDENCE_DIR = Path(__file__).resolve().parents[1] / "evidence" / "nightly"


def _collect_results(node) -> list:
    """Extrae la lista de casos de cualquier shape de promptfoo (v3/v4/redteam)."""
    if isinstance(node, list):
        out = []
        for item in node:
            out.extend(_collect_results(item))
        return out
    if isinstance(node, dict):
        for key in ("results", "testResults", "cases"):
            if key in node:
                found = _collect_results(node[key])
                if found:
                    return found
    return []


def latest_file() -> Path | None:
    files = sorted(glob.glob(str(EVIDENCE_DIR / "*-eval-results.json")) +
                   glob.glob(str(EVIDENCE_DIR / "*-redteam.json")))
    return Path(files[-1]) if files else None


def main() -> int:
    path = latest_file()
    if path is None:
        print("Sin evidencia en evidence/nightly/ (el scan no genero JSON)")
        return 1

    data = json.loads(path.read_text())
    cases = _collect_results(data)
    total = len(cases)
    fails = []
    for c in cases:
        passed = c.get("pass", None)
        if passed is False or c.get("failure"):
            prompt = (c.get("prompt") or c.get("vars") or {}).get("query", "") if isinstance(c.get("vars"), dict) else c.get("prompt", "")
            fails.append({
                "provider": c.get("provider") or "",
                "prompt": str(prompt)[:90].replace("\n", " "),
                "reason": (c.get("failure") or c.get("error") or "")[:80],
            })

    print(f"Evidencia: {path.name}")
    print(f"Tests: {total} | fallos: {len(fails)}")
    for f in fails[:10]:
        print(f" - [{f['provider']}] {f['prompt']} -> {f['reason']}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
