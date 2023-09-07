#!/usr/bin/python3
#
# Author: Loganathan R <logu.rangasamy@suse.com>
#

import yaml

d={}
with open("refhosts.yml") as f:
    d = yaml.safe_load(f)

for loc in d.keys():
    ploc = "Location: "+loc
    l=len(ploc)
    print("\n"+ploc)
    print("="*l)
    for host in d[loc]:
        hname = host['name']
        arch = host['arch']
        prod = host['product']
        vers = prod['version']
        major = str(vers['major'])
        minor = vers.get('minor', "")
        vnum = major
        if minor != "":
            vnum = major + "-" + minor
        print("%30s    %-10s    %10s    %s" % (hname, arch, prod['name'],vnum))
