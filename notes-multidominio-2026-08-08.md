# Corpus Ofensiva/Defensiva Multi-Dominio — KG expansion (2026-08-08)

Fuentes: PlexTrac/RedFox/WiFi pentesting 2026, Objection/Frida mobile, SANS SEC556 IoT, Proxmark3/Mifare, EFF/IMSI catcher 5G, IronVeil ROS2, Nordic BLE, Great Scott SDR, Binarly Secure Boot, SANS SEC565 adversary emulation. Para ingestión en Qdrant kg_full.

## 1. WIFI (802.11)
- **Ataques:** WEP (IV capture + aircrack), WPA/WPA2 (handshake capture + rockyou/hashcat -m 22000, hcxpcapngtool), WPA3 (downgrade a WPA2, PMF bypass, SAE brute), Evil Twin, Karma, deauth.
- **Herramientas:** aircrack-ng, airodump-ng, aireplay-ng, wifite2, hashcat, hcxpcapngtool, wifiphisher.
- **Defensa:** WPA3-SAE, PMF (Protected Management Frames) obligatorio, 802.1X/RADIUS, ocultar SSID (no es seguridad), detectores de Evil Twin.

## 2. MOBILE (Android/iOS)
- **Ataques:** SSL pinning bypass (Frida/Objection `ios sslpinning disable`), keychain extraction, runtime instrumentation, APK/IPA patching (objection patchapk/patchipa embed frida-gadget), reverse engineering (JADX, otool, class-dump), MITM (Burp/mitmproxy).
- **Herramientas:** Frida 17.5.2, Objection 1.12.4 (SensePost), MobSF, JADX, Burp Suite, Magisk, Brida.
- **Defensa:** cert pinning robusto, anti-tamper (detect frida-gadget), root/jailbreak detection, code obfuscation (ProGuard/R8), RASP.

## 3. IoT / HARDWARE
- **Ataques:** UART/JTAG/SPI debug ports, firmware extraction (flash programmer, logic analyzer Sigrok/Pulseview), firmware analysis (binwalk, strings, emulation QEMU), hardcoded credentials, insecure update (no signature), fault injection.
- **Herramientas:** Bus Pirate, logic analyzer, flashrom, binwalk, QEMU, Ghidra.
- **Defensa (Secure Boot):** Hardware Root of Trust (boot ROM verifies signature), secure element, PUF key derivation, anti-rollback, remote attestation, crypto-agility (PQC/Dilithium). CVE-2025-3052 (Secure Boot bypass via NVRAM gSecurity2=0) → dbx mitigation.

## 4. NFC / RFID
- **Ataques:** Mifare Classic 1K cloning (crypto1 weak, Proxmark3), magic cards (UID writable), replay, skimming, Mifare DESFire (AES, más fuerte).
- **Herramientas:** Proxmark3 (easy/rdv4), NFCopy, ChameleonMini, Flipper Zero.
- **Defensa:** Mifare DESFire EV2/EV3, AES-128, UID no clonable (hardware), rate limiting, rolling codes.

## 5. CELLULAR (2G-5G)
- **Ataques:** IMSI catcher / Stingray (false base station), 5G AKA flaw (ETH Zurich/TU Berlin: location tracking aún en 5G), jamming para downgrade a 2G, MITM SMS/calls, Rayhunter (detector en hotspots).
- **Defensa:** 5G SUCI (encrypted SUPI), disable 2G, baseband isolation, network anomaly detection.

## 6. ROBÓTICA (ROS 2)
- **Ataques:** DDS/RTPS unencrypted (SROS2 off), node spoofing, topic injection, command injection a actuadores, fleet C2 compromise.
- **Herramientas:** ROSPenTo, Roschaos, SROS2 (DDS security: X.509, access control).
- **Defensa:** SROS2 (DDS encryption + auth), network segmentation, physical access control, secure OTA.

## 7. BLE (Bluetooth Low Energy)
- **Ataques:** GATT sniffing (nRF52840 + Wireshark), MITM (Gattacker), unauthorized pairing, replay, fuzzing.
- **Herramientas:** nRF Sniffer, Gattacker, nRF Connect, Wireshark.
- **Defensa:** LE Secure Connections, bonding, encryption obligatoria, allowlist de dispositivos.

## 8. SDR (Software Defined Radio)
- **Ataques:** RX/TX en cualquier banda (433MHz, ISM, GSM), replay de keyfobs, jamming, protocol reverse engineering.
- **Herramientas:** HackRF One, RTL-SDR, GNU Radio, Ubertooth (BLE).
- **Defensa:** rolling codes (HMAC), frequency hopping, signal authentication.

## 9. RED/BLUE/PURPLE TEAM
- **Adversary emulation:** MITRE ATT&CK, CALDERA (autonomous), Atomic Red Team (10k+ stars), RTA, Stratus Red Team (cloud).
- **Red team:** stealth, TTPs reales, medir detección/respuesta blue team.
- **Blue team:** threat hunting, detection engineering, SIEM (Wazuh), purple team (cierre de gaps).
- **Frameworks:** MITRE ATT&CK, MITRE ATLAS (AI), OWASP LLM/Agentic.

## 10. Relaciones KG sugeridas
- (wifi, vulnerable_a, WPA2_handshake) ← (hashcat, crackea, WPA2)
- (mobile, vulnerable_a, ssl_pinning) ← (frida, bypass, ssl_pinning)
- (iot, vulnerable_a, uart_debug) ← (secure_boot, mitiga, firmware_tamper)
- (nfc, vulnerable_a, mifare_classic) ← (proxmark3, clona, mifare)
- (cellular, vulnerable_a, imsi_catcher) ← (5g_aka, flaw, location_tracking)
- (robotica, vulnerable_a, dds_unencrypted) ← (sros2, mitiga, dds_security)
- (ble, vulnerable_a, gatt_mitm) ← (nrf_sniffer, captura, gatt)
- (sdr, habilita, replay_keyfob) ← (hackrf, tx, any_band)
- (red_team, usa, caldera) ← (atomic_red_team, detection_test, mitre_attack)
