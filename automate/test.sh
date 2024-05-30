#!/bin/bash

# Read the first 100 IP addresses from the file and scan them in parallel
head -n 100 valid_ips.txt | parallel -j 10 nmap -sV {}

