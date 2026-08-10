# Wazuh: ajustar matcher 100606 (ssh lateral) - necesita decoder sshd o simplificar match

- id: t_7e63edfb
- status: blocked
- priority: 2
- assignee: stella
- created: 2026-08-09T20:40:41
- completed: 
- project: 

## Body

7/8 reglas MITRE disparan en runtime tras fix parent fantasma + regex PCRE. Pendiente 100606: no activa decoder con lineas sudo/sshd. Backup local_rules.xml.bak-parentfix-rules.
