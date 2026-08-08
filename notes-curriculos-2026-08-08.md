# Currículos universitarios de élite — corpus de conocimiento (2026-08-08)

Fuente: búsquedas web verificadas (MIT/UMich, Stanford, CMU CyLab, RISD, Harvard Kennedy, UWashington/Vanderbilt, ETH Zurich, Northeastern/Penn State). Para expansión del KG (segundo cerebro) y参考 de formación integral.

## 1. ROBÓTICA
- **Michigan Robotics (MS/PhD)**: ROB 501 Matemáticas para Robótica, ROB 550 Robotic Systems Lab. Áreas core: sensing, reasoning, acting. Breadth (1 curso por área) + Depth (1+ área) + Cognate (PhD, curso técnico externo). ROB 590 Directed Study.
- **Utah Robotics PhD**: Mechanics Core, Control Core, Cognition Core (elegir 1 cada uno).
- **MIT EECS Robotics**: investigación en hardware/algoritmos sensing→control→perception→manipulation.
- **Conocimiento clave**: cinemática/dinámica, SLAM, planificación de movimiento, control óptimo, percepción visual, FMCW/LiDAR, RL para manipulación, HRI.

## 2. ANÁLISIS DE DATOS / DATA SCIENCE
- **Stanford Stats & Data Sci (MS)**: STATS 200 (Theory), 203 (Regression/ANOVA), 209 (Causal Inference) o 263 (DoE), 217 (Stochastic Proc), 202 (Statistical Learning). + MS&E 236/CS 225 ML for Discrete Opt. Capstone DATASCI 194B/D/N, STATS 390 Consulting Workshop.
- **ETH Zurich MSc Data Science**: fundamentos teóricos + práctica, énfasis en teoría rigurosa.
- **QS 2026 #1 Data Science/AI**: MIT. Top: MIT, Stanford, Oxford, Cambridge, ETH Zurich, UC Berkeley, CMU.
- **Conocimiento clave**: álgebra lineal aplicada, probabilidad, inferencia bayesiana, causalidad (Pearl), ML (supervisado/no supervisado/DL), series temporales, ética de datos, optimización, visualización.

## 3. CIBERSEGURIDAD
- **CMU MSIS / MSIT-IS (CyLab)**: principios de infosec, systems engineering, info networking. Cursos: 14-513 Intro Computer Systems, 14-642 Embedded Systems, 14-735 Secure Coding, 14-740 (redes). Electivas: ML with Adversaries, Mobile/IoT Security. Aprendizaje: risk assessment, secure infra design, trade-offs security/policy/business.
- **Northeastern PhD Cybersecurity**: 48 créditos (16 más allá de maestría), GPA 3.5, disertación + defensa.
- **Penn State PhD Informatics**: 32 créditos + disertación, ~4 años.
- **Conocimiento clave**: criptografía, secure coding, redes seguras, pentesting (AD: Kerberoasting, BloodHound), DFIR, malware analysis (REMnux), SIEM (Wazuh), threat modeling (STRIDE), red team AI (prompt injection, system prompt leak, tool misuse), NIST CSF, MITRE ATT&CK/ATLAS.

## 4. DISEÑO GRÁFICO
- **RISD MFA Graphic Design**: 2 años. Educa "el ser humano completo" — acceso a toda la amplitud de la profesión. Studios + crítica. Fundamental: tipografía, sistema de diseño, narrativa visual, contexto histórico/crítico.
- **Conocimiento clave**: teoría del color, grid systems (Müller-Brockmann), tipografía (Bringhurst), diseño editorial, branding, motion (GSAP/Lenis), UX/UI, investigación de usuario, ética del diseño, herramientas (Figma, After Effects). Awwwards-level: motion primero, no glow.

## 5. DESARROLLO WEB
- **Bootcamps top 2026 (Course Report)**: Codesmith (13wk JS immensive, CS+ML), Codeworks (8-12wk, HTML/CSS/JS/Node/Express/SQL/NoSQL/Angular/React+DevOps), Fullstack Academy (JS+AI, React/Redux, NIST-aligned cyber), Launch School (mastery-based, 1200-1800h Core+Capstone), Ironhack, Turing College (AI Engineering).
- **UChicago/Fullstack**: full-stack 12wk.
- **Conocimiento clave**: HTML5/CSS3/ES6+, DOM, React/Redux, Node/Express, SQL+NoSQL, REST/GraphQL, DevOps/CD, sistemas de diseño, accesibilidad (WCAG), rendimiento, vibe coding + prompt engineering (2026), SOLID/Uncle Bob, TDD.

## 6. POLÍTICA / PUBLIC POLICY
- **Harvard Kennedy MPP**: API-101 (Markets/Market Failures), API-201 (Quant Analysis), API-501 (Policy Design/Delivery), API-102 (Policy Analysis), API-202/203 (Empirical Methods II), DPI-200 (Politics & Ethics), MLD-220 (Negotiation), API-500 (Spring Exercise). 2do año: PAC Seminar + Policy Analysis Exercise (PAE).
- **Harvard MPA**: Management/Leadership/Decision Sciences, Public Ethics, Political Institutions.
- **PhD Political Science (UWash/Vanderbilt)**: 4 general fields (American, Comparative, IR, Theory) + specialized (Methodology, Political Economy, Public Law). Methodology: POLS 500/501/503 (Research Design, Stats I/II, Quant Methods). Campos + comprehensive exams + dissertation.
- **Conocimiento clave**: economía pública, econometría, diseño de políticas, negociación, ética, teoría de juegos, métodos mixtos (cuant+cual), análisis de redes políticas, estadística causal.

## MAESTRÍAS Y DOCTORADOS (mapa)
| Disciplina | MS/MA | PhD |
|---|---|---|
| Robótica | U-Mich, ETH | U-Mich, Utah, MIT |
| Data Science | Stanford, ETH | MIT, Stanford, Cambridge |
| Ciberseguridad | CMU MSIT-IS, Northeastern | Northeastern, Penn State |
| Diseño Gráfico | RISD MFA | (MFA es terminal) |
| Web Dev | Bootcamps (Codesmith, Launch) | n/a |
| Política | Harvard MPP/MPA | UWash, Vanderbilt |

## APLICACIÓN AL KG
Este corpus alimenta el segundo cerebro (Qdrant cyber_knowledge + grafo). Relaciones sugeridas:
- (robótica, requiere, matemáticas) ← data science
- (ciberseguridad, usa, threat modeling) ← política (risk assessment)
- (diseño gráfico, colinda, desarrollo web) ← motion/UX
- (política, usa, análisis de datos) ← data science causal
- (web dev, soporta, diseño gráfico) ← sistemas de diseño
