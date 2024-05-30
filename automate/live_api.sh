is_valid_json() {
echo "$1" | jq . >/dev/null 2>&1
}

touch json_results.txt

while IFS= read -r url; do
response=$(curl -s "$url")

if is_valid_json "$response"; then
echo "URL $url has a valid JSON response:" >> json_results.txt
echo "$response" >> json_results.txt
else
echo "URL $url does not have a valid JSON response." >> json_results.txt
fi
done < apis.txt

