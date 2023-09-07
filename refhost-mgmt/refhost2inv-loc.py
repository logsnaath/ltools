#!/usr/bin/python3
#
# Author: Loganathan R <logu.rangasamy@suse.com>
#

import yaml

with open("refhosts.yml") as f:
    d = yaml.safe_load(f)

ansible_inventory = {}

for loc in d.keys():
    if loc not in ansible_inventory:
        ansible_inventory[loc] = {
            'children': {}
        }

    for host in d[loc]:
        name = host['name']
        arch = host['arch']

        if arch not in ansible_inventory[loc]['children']:
            ansible_inventory[loc]['children'][arch] = {
                'hosts': {},
                'vars': {}
            }

        ansible_inventory[loc]['children'][arch]['hosts'][name] = None
        prod = host['product']
        vers = prod['version']
        major = str(vers['major'])
        minor = vers.get('minor', "")
        vnum = major
        if minor is not None:
            vnum = major + "-" + minor
        ansible_inventory[loc]['children'][arch]['vars']['product_name'] = prod['name']
        ansible_inventory[loc]['children'][arch]['vars']['version'] = vnum

# Remove "null" entries from the output
yaml_str = yaml.dump(ansible_inventory, default_flow_style=False, sort_keys=True)
yaml_str = yaml_str.replace(": null", ":")
print(yaml_str)

