#!/usr/bin/env python3
"""
KG Ingestión — corpus curriculos universitarios (bonus plan 8h v3)
====================================================================
Lee el markdown de curriculos, lo chunkifica por sección, embedea via
nomic-embed-text en Mini (100.90.88.5:11434) y lo inserta en Qdrant
kg_full (Mini 100.90.88.5:6333). Idempotente: usa hash de chunk como ID.

NO requiere dependencias externas salvo requests (stdlib http fallback).
"""
import hashlib
import json
import re
import urllib.request

CORPUS = "/Users/quiquebedolla/.hermes/notes/ecosystem/curriculos-universitarios-elite-2026-08-08.md"
QDRANT_HOST = "100.90.88.5"
QDRANT_PORT = 6333
OLLAMA_HOST = "100.90.88.5"
COLLECTION = "kg_full"


def read_chunks(path: str):
    text = open(path, encoding="utf-8").read()
    # split por headers ## (secciones) y ### (subsecciones)
    parts = re.split(r"(?m)^##\s+", text)
    chunks = []
    for p in parts[1:]:
        title = p.splitlines()[0].strip()
        body = p.strip()
        if len(body) < 80:
            continue
        chunks.append({"title": title, "text": body[:1500]})
    return chunks


def embed(text: str):
    payload = json.dumps({"model": "nomic-embed-text:latest", "prompt": text}).encode()
    req = urllib.request.Request(
        f"http://{OLLAMA_HOST}:11434/api/embeddings",
        data=payload,
        headers={"Content-Type": "application/json"},
    )
    with urllib.request.urlopen(req, timeout=30) as r:
        return json.load(r)["embedding"]


def ensure_collection(dim: int):
    req = urllib.request.Request(
        f"http://{QDRANT_HOST}:{QDRANT_PORT}/collections/{COLLECTION}",
        headers={"Content-Type": "application/json"},
    )
    try:
        with urllib.request.urlopen(req, timeout=10) as r:
            if r.status == 200:
                return
    except Exception:
        pass
    body = json.dumps({"vectors": {"size": dim, "distance": "Cosine"}}).encode()
    req = urllib.request.Request(
        f"http://{QDRANT_HOST}:{QDRANT_PORT}/collections/{COLLECTION}",
        data=body,
        headers={"Content-Type": "application/json"},
        method="PUT",
    )
    with urllib.request.urlopen(req, timeout=10) as r:
        print(f"coleccion {COLLECTION} creada: {r.status}")


def upsert(points):
    body = json.dumps({"points": points}).encode()
    req = urllib.request.Request(
        f"http://{QDRANT_HOST}:{QDRANT_PORT}/collections/{COLLECTION}/points",
        data=body,
        headers={"Content-Type": "application/json"},
        method="PUT",
    )
    with urllib.request.urlopen(req, timeout=30) as r:
        return r.status


def main():
    chunks = read_chunks(CORPUS)
    print(f"[*] {len(chunks)} chunks del corpus")
    points = []
    for c in chunks:
        vec = embed(f"{c['title']}\n{c['text']}")
        pid = int(hashlib.md5(c["title"].encode()).hexdigest()[:12], 16)
        points.append(
            {
                "id": pid,
                "vector": vec,
                "payload": {
                    "title": c["title"],
                    "text": c["text"],
                    "source": "curriculos-universitarios-elite-2026-08-08.md",
                    "domain": "education-curriculum",
                },
            }
        )
    ensure_collection(len(points[0]["vector"]))
    status = upsert(points)
    print(f"[*] insertados {len(points)} puntos en {COLLECTION} (status {status})")


if __name__ == "__main__":
    main()
