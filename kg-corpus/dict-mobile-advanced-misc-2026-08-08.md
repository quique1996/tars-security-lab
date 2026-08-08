# Diccionario Mobile-Advanced/Misc-Final — KG expansion (2026-08-08)

Corpus denso para ingestión en Qdrant kg_full.

## Mobile Frida
Framework de hooking dinámico. Script en JS para interceptar funciones. Objection lo envuelve.

## Mobile Objection
CLI sobre Frida. SSL pinning disable, keychain dump, file system. Sin escribir JS.

## Mobile JADX
Decompiler de APK a Java. Lossy pero legible. Para entender lógica de app.

## Mobile APKTool
Decode/rebuild APK. smali editing para patches. Re-sign con keystore propia.

## Mobile Frida gadget
Inyectado en IPA re-signed. Sin jailbreak, sin proceso Frida detectable. Anti-detection.

## Mobile repackaging
Decodificar, insertar backdoor, re-empaquetar, instalar. Firma rota detectable.

## Mobile MitM
Burp/Proxyman entre app y server. Requiere cert install + pinning bypass.

## Mobile app transport security
iOS ATS, Android networkSecurityConfig. Forzar HTTPS. Bypass con config.

## Mobile device management
MDM para corporativo. Remote wipe, policy enforcement. Defiende contra pérdida.

## Mobile containerization
Workspace separado (Samsung Knox, iOS Managed). Aísla datos corporativos.

## Security chaos engineering
Inyectar fallos de red, auth, para validar resiliencia. Game days de seguridad.

## Security metrics MTTD
Mean Time To Detect. Reducir con mejor telemetría y automatización.

## Security metrics MTTR
Mean Time To Respond. Runbooks, automatización de containment aceleran.

## Purple team validation
Emular TTPs, medir si detección captura. Cerrar gaps con evidencia. Loop continuo.

## Continuous security validation
No confiar en "secure deployed". Tests, scanning, red team continuo.
