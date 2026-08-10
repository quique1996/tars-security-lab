#!/usr/bin/env python3
# Set AS-REP-roastable + unconstrained-delegation UAC flags on a Samba AD DC.
# Run ON the DC:  python3 set-uac-misconfigs.py
#
# WHY this over ldbmodify: `ldbmodify`/`ldbsearch` are NOT installed by default on
# Debian samba (they live in the `ldb-tools` package). The generic ldb-tools also
# risk skipping samba's ldb modules and corrupting sam.ldb. Samba's own SamDB
# python API loads the correct modules and is the safe, always-available path
# (python3-samba ships with the `samba` package).
#
# UAC bit reference:
#   NORMAL_ACCOUNT           0x00000200  (512)
#   DONT_EXPIRE_PASSWORD     0x00010000  (65536)
#   TRUSTED_FOR_DELEGATION   0x00080000  (524288)   <- unconstrained delegation
#   DONT_REQUIRE_PREAUTH     0x00400000  (4194304)  <- AS-REP roastable
# Samba normalises the account-type bit, so pass NORMAL+flags and read back to confirm.

from samba.samdb import SamDB
from samba.auth import system_session
from samba.param import LoadParm
import ldb

lp = LoadParm(); lp.load('/etc/samba/smb.conf')
db = SamDB('/var/lib/samba/private/sam.ldb', session_info=system_session(), lp=lp)

def setuac(sam, uac):
    res = db.search(base=db.domain_dn(), scope=ldb.SCOPE_SUBTREE,
                    expression="(sAMAccountName=%s)" % sam, attrs=["dn"])
    m = ldb.Message(); m.dn = res[0].dn
    m["userAccountControl"] = ldb.MessageElement(str(uac), ldb.FLAG_MOD_REPLACE, "userAccountControl")
    db.modify(m); print("set", sam, "->", uac)

# Edit these to match the accounts you created (samba-tool user create first).
setuac("asrep_svc", 512 + 65536 + 4194304)   # DONT_REQUIRE_PREAUTH -> AS-REP roastable
setuac("deleg_svc", 512 + 65536 + 524288)     # TRUSTED_FOR_DELEGATION -> unconstrained deleg

print("=== verify (bit & mask) ===")
for s in ("asrep_svc", "deleg_svc"):
    r = db.search(base=db.domain_dn(), scope=ldb.SCOPE_SUBTREE,
                  expression="(sAMAccountName=%s)" % s, attrs=["userAccountControl"])
    v = int(r[0]["userAccountControl"][0])
    print(s, v, "DONT_REQ_PREAUTH=%s" % bool(v & 0x400000), "TRUSTED_FOR_DELEG=%s" % bool(v & 0x80000))
