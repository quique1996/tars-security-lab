# CONOCIMIENTO AMPLIADO — LIBROS, TÉCNICAS Y CURSOS (2026-08-12)

> Fuentes: web_search multi-fuente (delinea, cyberdesserts, erdalozkaya, reddit, medium, antisyphon, offsec, confident-ai) + conocimiento del lab.

## 1. LIBROS DE CIBERSEGURIDAD (ranked 2026)

### Offensive / Red Team (prioridad para el lab)
| Libro | Autor | Por qué |
|---|---|---|
| **The Hacker Playbook 3** | Peter Kim | Metodología de engagement completa, AD attacks, adversary simulation. El punto de partida para OSCP. |
| **Hash Crack: Password Cracking Manual v3** | Joshua Picolet | Referencia de escritorio para credential testing — complementa nuestro hashcat/john. |
| **RTFM: Red Team Field Manual** | Ben Clark | No se lee, se tiene abierto durante un engagement. Referencia rápida de comandos. |
| **Red Team Development and Operations** | — | Distingue vulnerability assessment vs pentest vs red team — esencial para portfolio/entrevistas. |
| **Operator Handbook: Red Team + OSINT + Blue Team** | Netmux | Referencia de comandos para los 3 equipos — perfecto para el lab multi-rol. |
| **Tribe of Hackers Red Team** | — | Conocimiento tribal de red teamers reales, carreras, comunicación. |

### AI Security / LLM Red Teaming (el nicho)
| Libro | Autor | Por qué |
|---|---|---|
| **Adversarial Machine Learning** | Anthony Joseph et al. | Fundamentos académicos del adversarial ML. |
| **AI Security** | Clarence Chio & David Freeman | Clásico de seguridad de IA aplicada. |
| **Practical AI Security** | Himanshu Sharma | Enfoque práctico, alineado con lo que hacemos en el lab. |
| **Machine Learning Security Principles** | Gary McGraw et al. | Principios de seguridad ML desde la perspectiva de un experto en software security. |

### Defensivo / Blue Team
| Libro | Autor | Por qué |
|---|---|---|
| **The Blue Team Handbook** | Don Murdoch | El más recomendado en defensa. |
| **Intrusion Detection Honeypots: Detection through Deception** | Chris Sanders | Mejor libro de honeypots prácticos — sub-recomendado, ideal para nuestro lab. |
| **BTFM (Blue Team Field Manual)** | White & Clark | Referencia de blue team. |

### Fundamentos / Historia
| Libro | Autor | Por qué |
|---|---|---|
| **The Cuckoo's Egg** | Cliff Stoll | Orígenes del threat hunting, historia real — lectura obligatoria. |
| **Confident Cyber Security** | Jessica Barker | Factor humano y comunicación en seguridad. |

## 2. TÉCNICAS OFENSIVAS AVANZADAS (de investigación)

### LLM / AI Red Teaming (nuestro nicho — OWASP LLM Top 10 2025)
| Técnica | Descripción | Herramienta |
|---|---|---|
| **Direct Prompt Injection** | Instrucción maliciosa directa al LLM | PyRIT, garak |
| **Indirect Prompt Injection** | Payload escondido en contenido que el LLM procesa (RAG, web) | PyRIT, garak |
| **Jailbreaking (DAN-style)** | Role override + adversarial suffixes | garak (probe dan), PyRIT |
| **System Prompt Leakage (LLM07)** | Extraer el prompt del sistema | garak, promptfoo |
| **Excessive Agency (LLM06)** | Explotar que el agente tiene demasiados permisos de tools | PyRIT, agentic radar |
| **Encoding Evasion** | Ofuscar payload (base64, unicode, homoglyphs) para saltar filtros | garak (probe encoding) |
| **Multi-turn Attacks** | Construir el ataque a través de varias conversaciones | PyRIT (multi-turn) |
| **RAG Poisoning** | Inyectar contenido malicioso en la base vectorial | Giskard (auto RAG tests) |
| **Data Poisoning** | Contaminar el training/fine-tuning data | ART (IBM) |
| **Model Extraction** | Robar el modelo vía queries | ART (IBM) |

### Web (complemento al toolkit)
| Técnica | Descripción | Herramienta |
|---|---|---|
| **JWT alg:none / key confusion** | Forjar tokens manipulando algoritmo | jwt_tool (instalado) |
| **SSRF via redirects** | Abusar open redirects para alcanzar interno | ffuf, manual |
| **Prototype pollution** | Contaminar Object.prototype en JS | manual, Burp |
| **Web cache poisoning** | Envenenar cachés con headers | manual, Burp |
| **Race conditions** | TOCTOU en operaciones | Burp Turbo Intruder |
| **NoSQL injection** | Operadores $ne, $gt en MongoDB | manual |
| **XXE via SVG** | Exfiltrar archivos con SVG malicioso | manual |

## 3. CURSOS / TRAINING (2026)

| Curso | Proveedor | Nota |
|---|---|---|
| **AI Red Teaming 101** (10 episodios) | YouTube/offsec | Prompt injection, PyRIT, Spotlighting — gratis |
| **Attacking, Defending, and Leveraging AI/LLM Systems** | Antisyphon | 16h hands-on, CTFs, RAG security |
| **LLM Red Teaming** learning path | OffSec | Exploitation de LLM vulnerabilities |
| **OSCP** | OffSec | Certificación — roadmap de Quique |
| **HTB AI Red Teamer Path** | Hack The Box | El nicho — ya en el plan de certificación |

## 4. FUENTES PRIMARIAS
- delinea.com/blog/best-cybersecurity-books (15 libros para profesionales)
- blog.cyberdesserts.com/cybersecurity-books (SOC, Network, Pentest, AI 2026)
- erdalozkaya.com/best-cybersecurity-books-2026 (ranked por CISO)
- github.com/requie/AI-Red-Teaming-Guide (libros AI security)
- antisyphontraining.com (curso AI/LLM 16h)
- offsec.com/learning/paths/llm-red-teaming (learning path)
- confident-ai.com (tooling AI red team 2026)

## 5. CÓMO LO APLICAMOS AL LAB
1. **PyRIT + garak** → implementar las 10 técnicas LLM contra qwen3:8b (el scan real)
2. **jwt_tool** → probar JWT attacks contra Juice Shop (challenges de JWT)
3. **hashcat/john** → Hash Crack manual como referencia
4. **Honeypots** → instalar honeypot en el lab para validar Wazuh (libro de Sanders)
5. **RTFM/Operator Handbook** → referencia rápida en el repo
