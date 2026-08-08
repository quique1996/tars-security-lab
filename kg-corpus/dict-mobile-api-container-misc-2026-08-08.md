# Diccionario Mobile-API-Container-Misc — KG expansion (2026-08-08)

Corpus denso para ingestión en Qdrant kg_full.

## Mobile OWASP MASVS
Mobile Application Security Verification Standard. L1/L2 controls. MASWE mapea debilidades.

## Mobile MASTG
Mobile Application Security Testing Guide. iOS/Android. Static + dynamic + RE.

## Mobile root detection
Checks de /system, su binary, Magisk. Bypass con Frida/Objection (Android) o gadget (iOS).

## Mobile SSL pinning
Cert pinning en app. Bypass: Frida script, Objection disable, IPA patch. Burp CA install.

## Mobile obfuscation
ProGuard, R8, DexGuard, iOS obfuscators. Dificulta RE. No es seguridad real, retrasa.

## Mobile storage insecure
Credenciales en SharedPreferences/plist, databases sin encrypt. Keychain/Keystore usar.

## Mobile IPC
Android exportaciones (activities, services, content providers). Intent hijacking.

## Mobile permissions
Over-permissioning (location, contacts). Runtime permission model. Mínimo necesario.

## Mobile anti-debug
ptrace anti-attach, integrity checks. Bypass con Frida bypass scripts.

## API rate limiting
Throttle por IP/key. Previene brute force, scraping, DoS. Token bucket algorithm.

## API input validation
Schema validation (JSON Schema). Rechaza malformed. Previene injection, XXE.

## API authz models
RBAC, ABAC, ReBAC. Verificar en cada endpoint, no solo en UI. BOLA es común.

## API secrets in URL
API keys en query string = logs exfiltran. Usar headers. Rotate comprometidas.

## API CORS
Cross-Origin Resource Sharing. Wildcard con creds = peligro. Especificar origins.

## API versioning
Versionar para no romper clientes. Deprecar seguro (sunset headers).

## API webhook security
Verificar firma HMAC del webhook. Prevenir spoofing de eventos.

## Container read-only root
Filesystem read-only en pod. Previene escritura de malware. SecurityContext.

## Container seccomp
Filtra syscalls. Reduce superficie de kernel exploit. Profile default restringe.

## Container non-root
RUN as non-root user. Drop capabilities (NET_RAW, SYS_ADMIN). No privileged.

## Container image provenance
Sigstore/cosign firma imágenes. Verify antes de admitir. Supply chain trust.

## K8s network policy default-deny
Ingress deny por defecto. Allow explícito por app. Previene lateral movement.

## K8s pod security standards
Restricted: no priv, no hostPath, seccomp, runAsNonRoot. Admission enforce.

## K8s secrets encryption
KMS provider en etcd. No plaintext. External secrets operator para Vault.

## K8s RBAC audit
Revisar bindings, evitar cluster-admin amplio. Least privilege por namespace.

## K8s audit logging
Log de requests a API server. Detecta recon, privilege escalation, anomalous.

## K8s admission webhooks
Validating (rechaza), Mutating (inyecta sidecars). OPA/Gatekeeper, Kyverno.

## Defense deception grid
Honeypots + honeytokens + canarios distribuidos. Detectan movement en múltiples capas.

## Security logging
Centralizar logs (ELK, Splunk). Retención según compliance. Tamper-proofing.

## Alert triage
Correlacionar, priorizar por CVSS + exploitability + asset value. Reducir ruido.

## Incident runbook
Pasos concretos por tipo de incidente. Ejecutable bajo presión. Revisado regularmente.
