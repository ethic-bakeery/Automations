#!/bin/bash

# Define the IP range
ip_range="142.195"

# Output file to store RustScan results
rustscan_results="rustscan_results.txt"

# Number of concurrent scans
scan_concurrent=10

# Clear the output file
> $rustscan_results

# Function to scan an IP with RustScan
scan_ip() {
    local ip=$1
    echo "Scanning $ip with RustScan"
    rustscan -a $ip >> $rustscan_results
}

export -f scan_ip
export rustscan_results

# Loop through the IP range and scan each address with RustScan in parallel
for i in {0..255}; do
    for j in {0..255}; do
        ip="$ip_range.$i.$j"
        sem -j $scan_concurrent scan_ip $ip
    done
done

# Wait for all scans to complete
sem --wait

echo "RustScan complete. Results are stored in $rustscan_results."

