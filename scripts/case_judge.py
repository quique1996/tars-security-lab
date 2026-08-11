#!/usr/bin/env python3
"""case_judge.py — judge + KG + report para CASE nightly.
Corre en Mini. Recibe /tmp/battery-results.json, escribe reporte + KG.
Separado del shell para evitar bugs de heredoc/escaping.
"""
import json
import sys
import datetime
from pathlib import Path

sys.path.insert(0, str(Path.home() / "Projects/tars-security-lab/mcp-server"))
from mcp_server_tactical.tools import atlas_map, kg_ingest, report_gen, llm_judge
import urllib.request

def main():
    cases = json.load(open("/tmp/battery-results.json"))
    findings = []
    for c in cases:
        if c.get("verdict") in ("LEAK", "PROBE"):
            findings.append({
                "model": c["model"], "test": c["test"], "label": c["label"],
                "severity": "high" if c["verdict"] == "LEAK" else "medium",
                "technique": c["label"],
                "finding": f"{c['model']} {c['verdict']}: {c.get('hint', '')}",
                "evidence": c.get("response", "")[:200],
            })
    mapped = atlas_map(findings)["mapped"]
    for m in mapped:
        kg_ingest(m["model"], "vulnerable_to", m["technique"], f"case-{datetime.date.today().isoformat()}")

    judge_out = {"model": "none", "note": "no judge"}
    try:
        payload = json.dumps({
            "model": "glm-5.2:cloud",
            "prompt": "Clasifica hallazgos: " + json.dumps(findings)[:1500],
            "stream": False,
        }).encode()
        req = urllib.request.Request(
            "http://127.0.0.1:11434/api/generate", data=payload,
            headers={"Content-Type": "application/json"},
        )
        with urllib.request.urlopen(req, timeout=60) as r:
            judge_out = {"model": "glm-5.2:cloud", "response": json.loads(r.read()).get("response", "")[:1500]}
    except Exception as e:
        try:
            judge_out = llm_judge(json.dumps(findings)[:1500], "OWASP LLM Top10 + agentic")
        except Exception as e2:
            judge_out = {"model": "none", "note": f"cloud+local fail: {e2}"}

    r = report_gen(f"case-{datetime.date.today().isoformat()}", mapped, judge_out)
    print("REPORT:", r.get("path"), "| judge:", judge_out.get("model"), "| findings:", len(mapped))

if __name__ == "__main__":
    main()
