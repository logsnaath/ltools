#!/usr/bin/python3
#
# Author: Loganathan R <logu.rangasamy@suse.com>
#

import yaml

with open("refhosts.yml") as f:
    d = yaml.safe_load(f)

ansible_inventory = {}

for loc in d.keys():
    for host in d[loc]:
        name = host['name']
        arch = host['arch']

        if arch not in ansible_inventory:
            ansible_inventory[arch] = {
                'children': {}
            }
        
        if loc not in ansible_inventory[arch]['children']:
            ansible_inventory[arch]['children'][loc] = {
                'hosts': {},
                'vars': {}
            }

        ansible_inventory[arch]['children'][loc]['hosts'][name] = None
        prod = host['product']
        vers = prod['version']
        major = str(vers['major'])
        minor = vers.get('minor', "")
        vnum = major
        if minor is not None:
            vnum = major + "-" + minor
        ansible_inventory[arch]['children'][loc]['vars']['product_name'] = prod['name']
        ansible_inventory[arch]['children'][loc]['vars']['version'] = vnum

# Remove "null" entries from the output
yaml_str = yaml.dump(ansible_inventory, default_flow_style=False, sort_keys=True)
yaml_str = yaml_str.replace(": null", ":")
print(yaml_str)

