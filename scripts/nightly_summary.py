#!/usr/bin/env python3
"""nightly_summary.py — resumen de la corrida nocturna de red team (promptfoo).

Soporta el JSON de salida de promptfoo eval v3 (results.results[] con
success bool) y el formato redteam. Exit 0 aunque haya fallos de modelo
(la evidencia ES el resultado); exit 1 solo si no hay evidencia.

Uso: python3 scripts/nightly_summary.py
"""
from __future__ import annotations

import glob
import json
import sys
from pathlib import Path

EVIDENCE_DIR = Path(__file__).resolve().parents[1] / "evidence" / "nightly"


def _prompt_of(case: dict) -> str:
    p = case.get("prompt")
    if isinstance(p, dict):
        return str(p.get("raw") or p.get("display") or "")[:90].replace("\n", " ")
    return str(p or "")[:90].replace("\n", " ")


def _provider_of(case: dict) -> str:
    resp = case.get("response")
    if isinstance(resp, dict):
        prov = resp.get("provider")
        if isinstance(prov, dict):
            return str(prov.get("id") or prov.get("name") or "")
        if isinstance(prov, str):
            return prov
    prov = case.get("provider")
    return str(prov if isinstance(prov, str) else "")


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
    results_node = data.get("results", data)
    cases = results_node.get("results", []) if isinstance(results_node, dict) else []

    total = len(cases)
    fails = []
    for c in cases:
        if not isinstance(c, dict):
            continue
        # v3: success bool. redteam: failure/severity.
        failed = c.get("success") is False or c.get("failure") is True or \
                 c.get("severity") in ("high", "critical")
        if failed:
            fails.append({
                "provider": _provider_of(c),
                "prompt": _prompt_of(c),
                "reason": str(c.get("failure") or c.get("error") or "")[:80],
            })

    print(f"Evidencia: {path.name}")
    print(f"Tests: {total} | fallos: {len(fails)}")
    for f in fails[:10]:
        print(f" - [{f['provider'] or '?'}] {f['prompt']} -> {f['reason']}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
