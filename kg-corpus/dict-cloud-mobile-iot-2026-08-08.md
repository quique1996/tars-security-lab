# Diccionario Cloud/Container/Mobile/IoT — KG expansion (2026-08-08)

Corpus denso para ingestión en Qdrant kg_full.

## AWS IAM roles
Roles temporales (STS) reemplazan static keys. Access Analyzer detecta over-permissive. SCPs bloquean fleet-wide.

## AWS S3
Block Public Access + continuous scan. Lifecycle a Glacier 7 años. Inspector escanea ECR/Lambda.

## AWS GuardDuty
Detecta IMDS abuse, CredentialAccess, Exfiltration, runtime (reverse shell, crypto miner). VPC Flow Logs.

## AWS EC2 hardening
CIS Benchmarks, Session Manager (no SSH público), IMDSv2 obligatorio contra SSRF metadata theft.

## Azure Entra ID
Conditional Access zero-trust, Identity Protection señales de riesgo, MFA phishing-resistant (FIDO2).

## Azure Defender/Sentinel
Defender XDR + Sentinel (universal incident queue). Analytics rules para Entra ID.

## GCP security
IAM roles, VPC Service Controls, Cloud Armor, SCC (Security Command Center). Proyecto por entorno.

## Kubernetes network policies
Default-deny ingress por namespace, allow explícito. Calico microsegmentation. Previene lateral movement.

## Kubernetes OPA/Kyverno
Policy as Code, admission control. Bloquea imágenes fuera de trusted registry.

## Kubernetes Falco
eBPF runtime detection en containers/hosts/K8s. Integra con IR para aislar pods.

## Container Trivy
Scan de vulnerabilidades en imágenes y IaC. Parte de CI/CD.

## Android RE
APKTool (decode smali), JADX (decompile Java), smali patching para root bypass. Frida/Objection runtime.

## iOS jailbreak 2026
Rootless Dopamine/Palera1n (iOS 16-17). Frida gadget en IPA re-signed para apps con jailbreak detection.

## iOS SSL pinning
Objection ios sslpinning disable (~60%), si falla Frida script o IPA patching. Burp/Proxyman CA.

## iOS keychain
Extraer KeychainItem post-bypass (más valioso que tráfico). KeychainDumper.

## IoT Mirai
Brute force default creds, self-propagating worm. Mitigación: segment IoT de red crítica.

## IoT Aisuru/TurboMirai
20+ Tbps DDoS 2025-26 (700% YoY). Azure bloqueó 15.72 Tbps. AI precision flooding.

## IoT Eleven11bot/Kimwolf
86k / 2M+ dispositivos comprometidos. SSH brute (PumaBot), state-sponsored (IOCONTROL).

## Zigbee/Z-Wave/LoRaWAN
Protocolos M2M. Vulnerables a replay, sniffing. SDR para interceptar.

## BLE GATT
nRF52840, Gattacker. MITM, sniffing, spoofing de dispositivos. LE Secure Connections defiende.

## WiFi WPA3
SAE handshake (Dragonblood attacks), PMKID. aircrack-ng, hashcat. Evil Twin con hostapd.

## NFC Mifare
Proxmark3 clona Classic (Crypto1 roto). DESFire EV3 AES resistente. Flipper Zero para pruebas.

## RFID 125kHz
Proxmark3/LF clonado. HID tags sin cifrado. Defensa: tarjetas con cifrado.

## Hardware UART/JTAG
Debug interfaces exponen firmware. Bus Pirate, ChipWhisperer para glitching.

## Hardware fault injection
Voltage/clock glitch bypassa auth. Side-channel (power/EM) extrae secrets. PUF anti-tamper defiende.

## Firmware analysis
binwalk, strings, Ghidra disassembly, QEMU emulation. Chip-off para extraer flash.
