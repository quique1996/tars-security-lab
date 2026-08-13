# ANEXO — HexStrike 124 TOOLS INVENTARIO (verificado 2026-08-12)

> Fuente: `/health` del server HexStrike v6.0 (127.0.0.1:8889), 124 tools detectadas.
> Nota: el README dice "150+", el health reporta 124 disponibles — las restantes son categoría "additional" (14) sin binario.

## Herramientas por categoría

### Network & Recon (18)
nmap, masscan, rustscan, arp-scan, nbtscan, dnsenum, fierce, dnsrecon, enum4linux, enum4linux-ng, smbmap, rpcclient, responder, theharvester, subfinder, amass, httpx, fierce

### Web Application (22)
ffuf, dirb, dirsearch, gobuster, feroxbuster, wfuzz, katana, hakrawler, gau, waybackurls, paramspider, arjun, dalfox, x8, nuclei, nikto, wpscan, zaproxy, burpsuite, insomnia, postman, httpie

### Exploitation (12)
sqlmap, hydra, medusa, patator, metasploit, msfconsole, msfvenom, evil-winrm, searchsploit, exploit-db, nxc, xsser

### Password & Crypto (10)
hashcat, hashcat-utils, john, hash-identifier, ophcrack, hashpump, jwt-analyzer, libc-database, one-gadget, pwninit

### Binary Analysis & Reversing (14)
angr, pwntools, gdb, radare2, ghidra, objdump, strings, binwalk, ropgadget, ropper, checksec, exiftool, file, xxd

### Forensics & CTF (12)
volatility, volatility3, vol, autopsy, sleuthkit, bulk-extractor, foremost, photorec, testdisk, scalpel, steghide, stegsolve, zsteg, outguess

### Cloud & Container (10)
prowler, scout-suite, trivy, kube-hunter, kube-bench, docker-bench-security, checkov, terrascan, falco, clair

### OSINT & Intelligence (11)
sherlock, social-analyzer, recon-ng, maltego, spiderfoot, shodan-cli, censys-cli, have-i-been-pwned, wafw00f, urlscan, whois

### AI/ML & Misc (15)
aircrack-ng, aireplay-ng, airmon-ng, airodump-ng, kismet, tcpdump, tshark, wireshark, qsreplace, anew, uro, curl, api-schema-analyzer, graphql-scanner, autoscan

## Estado de instalación real (GEEKOM, no Kali)

| Categoría | Disponibles localmente | Requieren Kali |
|---|---|---|
| Network | subfinder, httpx, nmap (brew/Mini) | amass, masscan, responder... |
| Web | ffuf, nuclei, httpx | burpsuite, zaproxy, nikto, katana... |
| Exploitation | sqlmap | metasploit, hydra, evil-winrm... |
| Password | john, hashcat (nuevo 7.1.2) | ophcrack... |
| Binary | gdb (host) | angr, ghidra, pwntools (venv HexStrike tiene libs) |
| Forensics | — | volatility, steghide... |
| Cloud | trivy | prowler, scout-suite... |
| OSINT | spiderfoot (Docker) | sherlock, maltego, shodan-cli... |
| AI/Misc | — | aircrack-ng, kismet, wireshark... |

## Uso vía MCP (orquestado)

Las 124 tools se exponen como `mcp_hexstrike_*` cuando Hermes arranca con el server registrado. Las disponibles localmente ejecutan de verdad; las que requieren Kali reportan "tool not available" (esperado — GEEKOM no es Kali completo; las 150 tools asumen Kali 2024+).

## Gaps a cubrir (para 100% de tools funcionales)

1. Instalar en GEEKOM: hydra, nikto, wafw00f, theharvester (dnf)
2. Instalar vía Go: amass (en curso), gau (en curso), katana (en curso), naabu (en curso)
3. Kali VM (kali-lab, ya existe) puede cubrir el resto si se pasa por libvirt con el USB
4. El venv HexStrike ya tiene angr/pwntools libs — los binarios ghidra/radare2 son los que faltan
