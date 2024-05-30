#!/bin/bash

#!/bin/bash

# File containing the list of domains
domain_file="domains.txt"

# Output file to store subdomains
output_file="subdomains_all_tools.txt"

temp_file="temp_subdomains.txt"

# Clear the output file
> $output_file
> $temp_file

# Check if the domain file exists
if [[ ! -f $domain_file ]]; then
    echo "Domain file not found!"
    exit 1
fi

while IFS= read -r domain; do
    if [[ -n $domain ]]; then
        echo "Scanning $domain with all tools"

        echo "Using Sublist3r"
        sublist3r -d "$domain" -o sublist3r_results.txt
        cat sublist3r_results.txt >> $temp_file
        rm sublist3r_results.txt

        echo "Using Assetfinder"
        assetfinder --subs-only "$domain" >> $temp_file

        echo "Using Dnsrecon"
        dnsrecon -d "$domain" -t brt | grep "A" | awk '{print $3}' >> $temp_file
    fi
done < "$domain_file"

sort -u $temp_file -o $output_file
rm $temp_file

echo "Subdomain enumeration completed. Results are stored in $output_file."

