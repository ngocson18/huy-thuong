#!/bin/bash
while read filename; do
    if [ ! -f "js/$filename" ] || [ $(stat -c%s "js/$filename") -lt 100 ]; then
        echo "Downloading $filename"
        curl -s -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" \
             -o "js/$filename" \
             "https://chungdoi.com/_next/static/chunks/$filename"
        sleep 0.5
    fi
done < <(python3 -c '
import re
with open("/home/nolan/Downloads/saveweb2zip-com-chungdoi-com/js/webpack-a1dc0da509b61474.js") as f:
    content = f.read()
prefix_dict = {}
match1 = re.search(r"\(\{([^}]*)\}\)\[e\]\|\|e", content)
if match1:
    for k, v in re.findall(r"(\w+):\"([^\"]+)\"", match1.group(1)):
        if "e" in k: k = str(int(float(k)))
        prefix_dict[k] = v
match2 = re.search(r"\.\"\\+\((\{.*?\})\)\[e\]\\+\"\.js\"", content)
if match2:
    for chunk_id, hash_val in re.findall(r"(\w+):\"([^\"]+)\"", match2.group(1)):
        if "e" in chunk_id: chunk_id = str(int(float(chunk_id)))
        prefix = prefix_dict.get(chunk_id, chunk_id)
        print(f"{prefix}.{hash_val}.js")
')
