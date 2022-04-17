#!/usr/bin/python3

url='http://www.memtest.org/'

import re
url_without_ending_forward_slash = re.sub("/$", "", url)

import requests
response = requests.get(url_without_ending_forward_slash)

from bs4 import BeautifulSoup
soup = BeautifulSoup(response.text, 'html.parser')

elements = soup.find_all(lambda tag: "USB" in tag.text)
for element in elements:
    if element.get('href'):
        print(url_without_ending_forward_slash + '/' + element.get('href'))
        break

