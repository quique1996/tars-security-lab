# TARS Security Lab

AI red teaming and cybersecurity lab running on a multi-node Tailscale fleet.

## Lab Infrastructure

| Component | Node | Status |
|-----------|------|--------|
| Wazuh SIEM (manager + indexer + dashboard) | GEEKOM | 4/4 agents active |
| DVWA (Damn Vulnerable Web App) | GEEKOM | Docker Up |
| OWASP Juice Shop | GEEKOM | Docker Up |
| OWASP WebGoat | GEEKOM | Docker Up |
| Kali Linux VM | GEEKOM | libvirt/qemu, 4GB RAM |
| Garak (NVIDIA) | GEEKOM | v0.16.0, nightly pipeline |
| PyRIT (Microsoft) | GEEKOM | v1.0.1, verified working |
| Caldera (MITRE) | GEEKOM | Cloned, service pending |
| Node Exporter + Prometheus + Grafana | Mini | 3/3 nodes monitored |

## Fleet Nodes

| Node | Hardware | Role |
|------|----------|------|
| Air | MacBook Air M1 8GB | RAG ingester, Hermes gateway, Bokken ops |
| Mini | Mac mini M4 16GB | Qdrant vector store, EXO, observability, n8n |
| GEEKOM | Ryzen 9 7940HS 16GB | Ollama (6 models), Wazuh SIEM, Docker labs, Kali VM |

## RAG Corpus

| Collection | Points | Domain |
|------------|--------|--------|
| bgw_knowledge | 3,293 | Blender → Godot → WebGPU |
| cyber_knowledge | 6,111 | Red/Blue/Purple/Grey + AI red teaming |
| hermes_brain | 700+ | Second brain (notes indexed) |

## Red Team Tools

- **Garak 0.16.0**: vulnerability scanning of LLMs (nightly 03:30)
- **PyRIT 1.0.1**: automated multi-turn attack orchestration
- **First finding**: llama3.2:3b responds HACKED to instruction override
- **Sigma rules**: detection engineering from SigmaHQ
- **Atomic Red Team**: 3,869 atomic tests mapped to MITRE ATT&CK

## Documentation (curso nivel 1)

- **Wazuh architecture**: `docs/WAZUH-ARCHITECTURE-2026-08-19.md` — capa de detección, reglas custom, purple loop
- **Attack chains**: `docs/ATTACK-CHAINS-2026-08-19.md` — AD Kerberoast, Agentic AI Red Team, Purple loop
- **Prompt injection findings**: `docs/PROMPT-INJECTION-FINDINGS-2026-08-19.md` — findings consolidados multi-herramienta

## Roadmap
- [x] Wazuh 4/4 agents active
- [x] PyRIT verified working
- [x] Garak nightly pipeline
- [x] RAG cyber corpus (6,111 chunks, 40 sources)
- [ ] Caldera as service + monthly exercise
- [ ] DeepEval golden dataset
- [ ] Publish 3-5 skills as OSS
- [ ] Bug bounty baseline scan
