#!/usr/bin/python3
#
# Author: Loganathan R <logu.rangasamy@suse.com>
# Usage:
# ./get_pkg2test_map.py 'https://openqa.suse.de/tests/overview?distri=sle&version=12-SP5&build=20230724-2&groupid=414'

import requests
import urllib.parse as urlp
from bs4 import BeautifulSoup
import sys
import json
import re

def get_links(url):
    reqs = requests.get(url)
    soup = BeautifulSoup(reqs.text, 'html.parser')
    return [link.get('href') for link in soup.find_all('a')]

def extract_test_links(url):
    test_links = []
    m = re.compile(r"tests\/\d+")
    for testlink in get_links(url):
        if testlink and m.search(testlink):
            test_links.append("https://openqa.suse.de" + testlink)
    return test_links

def fetch_obj_names(url):
    print("\n==> Processing:", url)
    resp = requests.get(url + "/details_ajax")
    return resp.json()["modules"]

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: " + sys.argv[0] + " <single quoted URL>")
        sys.exit(1)

    url = sys.argv[1]
    print("URL:", url)
    qs = urlp.parse_qs(urlp.urlparse(url).query)
    result_map_file = "openqa-result_" + qs['distri'][0] + "_" + qs['version'][0] + \
                        "_" + qs['build'][0] + "_" + qs['groupid'][0] + ".json"
    print("\n===> Result maps:", result_map_file) 

    test_links = extract_test_links(url)

    name_to_results = {}
    if not test_links:
        print("No test links found.")
    else:
        for lnk in test_links:
            tnames = [module['name'] for module in fetch_obj_names(lnk)]
            print(tnames)
            for tname in tnames:
                module_lnk = lnk + "#step/" + tname + "/1"
                name_to_results.setdefault(tname, []).append(module_lnk)
   
    with open(result_map_file, 'w') as result_map:
        json.dump(name_to_results, result_map, indent=2, sort_keys=True)
    # print(json.dumps(name_to_results, indent=2, sort_keys=True))
    print("\n===> Result maps:", result_map_file) 

## lynx -dump -nolist https://openqa.suse.de/tests/11651966/settings_ajax|grep -A9 _ISSUES
