#!/usr/bin/env python3
"""Inject discovery rules + 100531 suppression into local_rules.xml.
Structured XML edit — inserts before the closing </group> of the honeypot,suspicious_process group.
Usage: python3 inject_rules.py <path-to-local_rules.xml>
"""
import re
import sys

def main(path: str) -> None:
    with open(path, "r", encoding="utf-8") as f:
        xml = f.read()

    if 'rule id="100600"' in xml:
        print("SKIP: discovery rules already present")
        return

    # Find the honeypot,suspicious_process group closing </group> — it is the
    # group that contains 100530 (suspicious process / web shell).
    m = re.search(r'(<group name="honeypot,suspicious_process,.*?)(</group>)', xml, re.S)
    if not m:
        print("ERROR: honeypot,suspicious_process group not found")
        sys.exit(1)

    block = """
  <rule id="100600" level="8">
    <match>whoami|id -u|lastlog|logname</match>
    <description>MITRE T1033: User discovery command executed</description>
    <group>discovery,mitre_attack</group>
    <mitre><id>T1033</id></mitre>
  </rule>
  <rule id="100601" level="8">
    <match>ps aux|ps -ef|ps -ax</match>
    <description>MITRE T1057: Process discovery command executed</description>
    <group>discovery,mitre_attack</group>
    <mitre><id>T1057</id></mitre>
  </rule>
  <rule id="100602" level="6">
    <match>cat /etc/passwd|getent passwd</match>
    <description>MITRE T1033: Account enumeration via passwd file</description>
    <group>discovery,mitre_attack</group>
    <mitre><id>T1033</id></mitre>
  </rule>
  <rule id="100531" level="0">
    <if_sid>100530</if_sid>
    <match>tailscaled|sshd|be-child ssh</match>
    <description>Suppressed: 100530 triggered by admin SSH session via tailscaled</description>
    <group>honeypot,suspicious_process,</group>
  </rule>
"""
    xml = xml[:m.end(1)] + block + xml[m.end(1):]
    with open(path, "w", encoding="utf-8") as f:
        f.write(xml)
    print("INJECTED: 100600, 100601, 100602, 100531")

if __name__ == "__main__":
    main(sys.argv[1])
