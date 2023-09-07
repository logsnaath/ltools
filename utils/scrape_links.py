#!/usr/bin/python3
#
# Author: Loganathan R <logu.rangasamy@suse.com>
#

import requests
from bs4 import BeautifulSoup
import sys
from urllib.parse import urljoin

def get_absolute_url(base_url, relative_url):
    return urljoin(base_url, relative_url)

if len(sys.argv) != 2:
    print("Usage: python scrape_links.py <URL>")
    sys.exit(1)

# Get the URL from the command line argument
url = sys.argv[1]

# Send an HTTP GET request to the URL
response = requests.get(url)

# Check if the request was successful (status code 200)
if response.status_code == 200:
    # Parse the page content using BeautifulSoup
    soup = BeautifulSoup(response.content, 'html.parser')
    
    # Find all the links on the page (anchor tags)
    links = soup.find_all('a')
    
    # Create a text file to save the links
    with open('links.txt', 'w') as file:
        for link in links:
            # Get the href attribute of each link
            href = link.get('href')
            if href:
                # Convert relative links to absolute links
                absolute_url = get_absolute_url(url, href)
                file.write(absolute_url + '\n')
    
    print("Links saved to links.txt")
else:
    print(f"Failed to retrieve the webpage. Status code: {response.status_code}")

