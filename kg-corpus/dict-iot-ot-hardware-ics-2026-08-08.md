# Diccionario IoT/OT/Hardware/ICS — KG expansion (2026-08-08)

Corpus denso para ingestión en Qdrant kg_full.

## ICS Modbus
Protocolo serial/TCP sin auth. Manipular registros (coils, holding). ModbusPal, pymodbus.

## ICS Profinet
Industrial Ethernet Siemens. Recon de dispositivos, manipulación de tags.

## ICS SCADA
Supervisory Control. HMI expuesto = control remoto. CVEs en Ignition, Indusoft.

## ICS PLC
Programmable Logic Controller. Ladder logic, firmware mod. Manipulación de proceso físico.

## ICS HMI
Human Machine Interface. Panel de control. XSS/RCE en HMI web. Acceso = control total.

## ICS Stuxnet
Gusano que saboteó centrifugas iraníes vía PLC. Precedente de ciber-guerra física.

## OT Purdue levels
0 sensor, 1 PLC, 2 HMI/supervisory, 3 control, 3.5 DMZ, 4-5 IT. Segmentación por zona.

## OT IT/OT convergence
IIoT disolvió boundary. 11+ links no documentados IT-OT promedio. Zero trust dentro de zonas.

## OT ransomware
Dragos: ransomware dirigido a OT (LockBit en pipelines). Destruye procesos físicos.

## OT detection
Monitorización de trafico Modbus/Profinet anómalo. No es IDS tradicional (ICS-aware).

## IoT default creds
admin/admin, root/root. Mirai los brute-forcea. Cambiar + firmware updates.

## IoT firmware extraction
UART (TX/RX), JTAG/SWD, chip-off. Volcado de flash para análisis.

## IoT web interface
Muchos dispositivos con web admin vulnerable (XSS, auth bypass). Shodan los expone.

## IoT UPnP
Universal Plug and Play expuesto. Permite reconfiguración remota. Deshabilitar.

## IoT Zigbee
2.4GHz mesh. Sniffing con TI CC2531. Replay de comandos. Zigbee3 con AES.

## IoT Z-Wave
Sub-GHz. Menos expuesto que WiFi. Sniffing SDR. S0/S2 security.

## IoT LoRaWAN
Long range WAN. Keys en dispositivo vulnerables. Replay de uplink.

## IoT MQTT
Broker IoT sin auth (1883). Suscribirse a # para ver todo el tráfico. TLS + auth.

## BLE advertising
Beacons, wearables. Sniffing con nRF52840. Direcciones aleatorias dificultan tracking.

## BLE pairing
Just Works (vulnerable a MITM), Passkey (MITM), Numeric Comparison (LE Secure).

## BLE GATT hacking
Gattacker, Btlejack. Spoofing de servicios, write de characteristics no authz.

## NFC 13.56MHz
ISO 14443. Mifare Classic Crypto1 roto (Proxmark3 clona). DESFire EV3 AES.

## NFC HID cards
125kHz EM4100 sin cifrado. Clonado con T5577. Defensa: HID iClass (CSN cifrado).

## NFC payment
EMV contactless. Relay attack (TAP/relay). Defensa: distance bounding.

## SDR fundamentals
RX/TX de señales. HackRF (1MHz-6GHz), RTL-SDR (cheap RX), BladeRF, USRP.

## SDR GNURadio
Framework de DSP en Python/C++. Flowgraphs para demodular.

## SDR replay attack
Grabar señal de keyfob/garage, re-transmitir. Rolling code mitiga (pero captura de 2+).

## SDR jamming
Interferencia de señal. Ilegal sin licencia. Demuestra vulnerabilidad de canal.

## Hardware UART
3.3V/5V serial. TX/RX/GND. Baud rate discovery (9600-115200). Consola root común.

## Hardware JTAG/SWD
Debug de chips (ARM). Extrae firmware, controla ejecución. SWD es JTAG reducido.

## Hardware SPI/I2C
Flash chips (SPI), EEPROM (I2C). Leer con Bus Pirate, CH341A. Extrae firmware.

## Hardware glitching
ChipWhisperer. Voltage/clock glitch para saltar checks (auth, boot). Fault injection.

## Hardware side-channel
Power analysis (DPA), EM emisiones. Extrae claves AES/RSA. Contramedida: blinding.

## Hardware PUF
Physically Unclonable Function. Fingerprint único del chip. Raíz de confianza.

## Hardware Secure Boot
Firma de bootloader. Previene firmware malicioso. Chain of trust (ROM→BL→OS).

## Hardware Root of Trust
Crypto co-processor (TPM, Secure Enclave). Almacena claves, atestación.

## Hardware anti-tamper
Sensores de apertura, borrado de claves en intrusión. Smart cards, HSM.

## Firmware binwalk
Extrae archivos embebidos, filesystems (SquashFS, CramFS). Entropía para detectar comprimido.

## Firmware Ghidra
Cargar binario, analizar entry point, decompile. Arquitectura (MIPS, ARM, x86).

## Firmware emulation
QEMU user-mode para ejecutar binarios. Emular servicios para dynamic analysis.

## Firmware hardcoded
Claves, backdoors, certs en firmware. Strings revela. Actualizar no borra si OTA insegura.

## IoT botnet defense
Segmentación de red IoT, inventory, patch management, monitoreo de tráfico anómalo.

## OT incident response
ISACs (dragos), playbooks específicos OT. No reiniciar PLC ciegamente (estado físico).

## Industrial protocol security
ACLs en switches, VLANs, firewalls industriales (Tofino). Deep packet inspection OT.

## Smart grid threats
AMI meters, SCADA de utilidades. Manipulación de medición, blackout coordinado.

## Vehicle CAN bus
Diagnóstico OBD-II. Sniffing CAN (socketcan). Inyección de comandos (aceleración, frenos).

## Medical device security
Pacemakers, infusoras con redes. FDA guidances. Riesgo de vida. Patch difícil (FDA approval).
