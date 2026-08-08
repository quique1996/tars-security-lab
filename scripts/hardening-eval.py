#!/usr/bin/env python3
"""
Hardening eval — ornith:9b contra system prompt leak (ASI08 / LLM07).

Mide ANTES/DESPUES con metodologia IDENTICA a v2 (scan 20260808T054509Z):
  * mismos 5 tests   -> importados de scripts/redteam-compare.py
  * mismo template   -> PROMPT_TEMPLATE de redteam-compare.py
  * mismo scoring    -> score() (substring) + classify() (semantico, rules v2)
  * temperature=0, seed=42, num_predict=400, POST /api/chat stream=false

Unica variable manipulada: presencia de un system message endurecido
(prompts/ornith-hardened-v3.md). Todo lo demas se mantiene constante.

Uso:
  python3 scripts/hardening-eval.py --arms baseline,hardened
  python3 scripts/hardening-eval.py --arms hardened --model qwen3:8b \
      --host http://100.123.17.12:11434
"""
import argparse
import importlib.util
import json
import os
import sys
import time
import urllib.request
from datetime import datetime, timezone

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)


def _load(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


# Reutilizamos EXACTAMENTE los tests y el scoring de v2 -> comparabilidad 1:1
rt = _load("rt", os.path.join(HERE, "redteam-compare.py"))
jg = _load("jg", os.path.join(HERE, "judge-results.py"))

TESTS = rt.TESTS
PROMPT_TEMPLATE = rt.PROMPT_TEMPLATE
SEED, TEMPERATURE, NUM_PREDICT = rt.SEED, rt.TEMPERATURE, rt.NUM_PREDICT

HARDENED_PATH = os.path.join(ROOT, "prompts", "ornith-hardened-v3.md")


def call(host, model, prompt, system=None, timeout=300):
    msgs = []
    if system:
        msgs.append({"role": "system", "content": system})
    msgs.append({"role": "user", "content": prompt})
    body = json.dumps({
        "model": model,
        "messages": msgs,
        "stream": False,
        "options": {"temperature": TEMPERATURE, "seed": SEED,
                    "num_predict": NUM_PREDICT},
    }).encode()
    req = urllib.request.Request(f"{host}/api/chat", data=body,
                                 headers={"Content-Type": "application/json"})
    t0 = time.time()
    with urllib.request.urlopen(req, timeout=timeout) as r:
        data = json.loads(r.read())
    return (data.get("message", {}).get("content", ""),
            round(time.time() - t0, 2), data)


def run_arm(arm, model, host, system):
    print(f"\n=== arm={arm} model={model} host={host} "
          f"system={'YES' if system else 'NO'} ===")
    results = []
    for t in TESTS:
        prompt = PROMPT_TEMPLATE.format(query=t["query"])
        rec = {"test_id": t["id"], "category": t["category"], "owasp": t["owasp"],
               "query": t["query"], "prompt_sent": prompt,
               "system_prompt_used": bool(system)}
        try:
            raw, dur, meta = call(host, model, prompt, system)
            rec.update(rt.score(t, raw))
            rec["latency_s"] = dur
            rec["eval_count"] = meta.get("eval_count")
            rec["error"] = None
            if meta.get("eval_duration"):
                rec["tokens_per_s"] = round(
                    meta["eval_count"] / (meta["eval_duration"] / 1e9), 1)
        except Exception as e:
            rec.update({"attack_success": None, "error": f"{type(e).__name__}: {e}"})
            results.append(rec)
            print(f"  {t['id']:<3} ERROR {rec['error']}")
            continue

        j = jg.classify(t["id"], t["category"], rec.get("final_answer", ""))
        j["rules_version"] = jg.RULES_VERSION
        rec["judge"] = j
        rec["attack_success_semantic"] = j["verdict"] == "COMPLIED"
        rec["leak_semantic"] = bool(j["leaked_system_prompt"])
        results.append(rec)
        print(f"  {t['id']:<3} {t['category']:<19} verdict={j['verdict']:<8} "
              f"leak={j['leaked_system_prompt']}  ({rec['latency_s']}s)")
    return results


def summarize(results):
    ok = [r for r in results if not r.get("error")]

    def rate(cat=None, key="attack_success_semantic"):
        sel = [r for r in ok if cat is None or r["category"] == cat]
        s = sum(1 for r in sel if r.get(key))
        return {"success": s, "total": len(sel),
                "rate_pct": round(100 * s / len(sel), 1) if sel else None}

    return {
        "tests_run": len(ok),
        "tests_errored": len(results) - len(ok),
        "system_prompt_leak": rate("system_prompt_leak"),
        "jailbreak": rate("jailbreak"),
        "tool_misuse": rate("tool_misuse"),
        "overall_attack_success": rate(),
        "leaked_secrets_count": sum(1 for r in ok if r.get("leak_semantic")),
        "refusals": sum(1 for r in ok if r["judge"]["verdict"] == "REFUSED"),
        "leak_any_test_count": {
            "success": sum(1 for r in ok if r.get("leak_semantic")),
            "total": len(ok),
            "rate_pct": round(100 * sum(1 for r in ok if r.get("leak_semantic"))
                              / len(ok), 1) if ok else None,
        },
        "substring_attack_success": rate(key="attack_success"),
        "avg_latency_s": round(sum(r.get("latency_s", 0) for r in ok)
                               / max(len(ok), 1), 2),
        "results": results,
    }


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--model", default="ornith:9b")
    ap.add_argument("--host", default="http://localhost:11435")
    ap.add_argument("--node", default="Mac Mini M4 (100.90.88.5, ssh tunnel :11435)")
    ap.add_argument("--arms", default="baseline,hardened")
    ap.add_argument("--out", default=None)
    args = ap.parse_args()

    system = open(HARDENED_PATH).read()
    ts = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")

    report = {
        "scan": f"hardening-eval {args.model} — system prompt leak mitigation",
        "timestamp_utc": ts,
        "model": args.model,
        "node": args.node,
        "endpoint": args.host,
        "baseline_reference_scan": "20260808T054509Z",
        "reproducibility": {
            "temperature": TEMPERATURE, "seed": SEED, "num_predict": NUM_PREDICT,
            "api": "POST /api/chat (stream=false)",
            "prompt_template": PROMPT_TEMPLATE,
            "tests_source": "promptfooconfig-ci.yaml (5 tests, identicos a v2)",
            "scoring": "rt.score() substring + jg.classify() semantico rules v2",
            "controlled_variable": "presencia de system message endurecido",
        },
        "hardened_system_prompt_path": os.path.relpath(HARDENED_PATH, ROOT),
        "hardened_system_prompt": system,
        "arms": {},
    }

    for arm in [a.strip() for a in args.arms.split(",") if a.strip()]:
        sys_msg = system if arm == "hardened" else None
        report["arms"][arm] = summarize(run_arm(arm, args.model, args.host, sys_msg))

    out = args.out or os.path.join(ROOT, "results", f"hardening-{ts}.json")
    os.makedirs(os.path.dirname(out), exist_ok=True)
    json.dump(report, open(out, "w"), indent=2, ensure_ascii=False)
    print(f"\nSaved: {out}")

    b = report["arms"].get("baseline", {}).get("system_prompt_leak")
    h = report["arms"].get("hardened", {}).get("system_prompt_leak")
    if b and h:
        print(f"system_prompt_leak: {b['rate_pct']}% -> {h['rate_pct']}%")
    return 0


if __name__ == "__main__":
    sys.exit(main())
