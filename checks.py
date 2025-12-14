# all files
# navigation
# imgs

# forward<->backward links, ru<->eng links
# title and meta

import os
from bs4 import BeautifulSoup as bs4
from urllib.parse import urlparse
from termcolor import colored


def get_htmls(search_dir="."):
	htmls = []
	for root, dirs, files in os.walk(search_dir):
		for file in files:
			if file.lower().endswith(".html") and not root.startswith(".\\TODO"):
				htmls.append([root, file])
	return htmls

def norm_path(*args):
	return os.path.normpath(os.path.join(*args))

def get_soup(html_file):
	with open(html_file, "r", encoding="utf-8") as f:
		content = f.read()

	return bs4(content, "lxml")

def get_refs(html_file):
	soup = get_soup(html_file)
	folder = os.path.dirname(html_file)

	refs = {
		"pages": {},
		"files": set(),
		"urls": set(),
		"imgs": set(),
	}

	for link in soup.select("a:not(div.header a)"):
		href = link["href"]

		if href.startswith("http"):
			refs["urls"].add(href)
			continue

		parsed_ref = urlparse(href)

		if parsed_ref.path.endswith(".html"):
			page = norm_path(folder, parsed_ref.path)
			refs["pages"].setdefault(page, set())

			fragment = parsed_ref.fragment
			if fragment:
				refs["pages"][page].add(fragment)

			continue

		refs["files"].add(norm_path(folder, href))

	return refs

def anchorQ(page, fragment):
	return get_soup(page).find(id=fragment) is not None


if __name__ == "__main__":
	files = get_htmls(".")
	# for f in files:
	#	print(f)

	refs = get_refs("en/chapter-01.html")


	print("\n")
	print(colored("PAGES:", "green"))
	for page, fragments in refs["pages"].items():
		if not os.path.isfile(page):
			print(colored(page, "red"))
		elif not fragments:
			print(page)
		else:
	 		print(f"{page}:", end=" ")
	 		for a in fragments:
	 			if anchorQ(page, a):
	 				print(a, end=" ")
	 			else:
	 				print(colored(a, "red"), end=" ")
	 		print("")
	print("")

	print(colored("FILES:", "blue"))
	for file in refs["files"]:
		if not os.path.isfile(file):
			print(colored(f"{file}", "red"))
		else:
			print(f"{file}")
	print("")

	print(colored("URLS:", "yellow"))
	for url in refs["urls"]:
	 	print(f"{url}")
	print("")

	print(colored("IMGS:", "magenta"))
	for img in refs["imgs"]:
	 	print(f"{img}")
	print("")



