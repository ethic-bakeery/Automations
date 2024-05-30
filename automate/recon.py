import shodan
import json

# Your Shodan API key
API_KEY = ''

# Initialize the Shodan client
api = shodan.Shodan(API_KEY)

# Function to read lines from a file and return as a list
def read_list_from_file(file_path):
    with open(file_path, 'r') as file:
        return [line.strip() for line in file if line.strip()]

# Read hosts and keywords from files
hosts = read_list_from_file('hosts.txt')
keywords = read_list_from_file('keywords.txt')

# Function to perform search
def perform_search(host, keyword):
    query = f'hostname:"{host}" title:"{keyword}"'
    try:
        results = api.search(query)
        print(f'Search query: {query}')
        print(f'Results found: {results["total"]}')
        return results
    except shodan.APIError as e:
        print(f'Error: {e}')
        return None

# Perform searches and collect results
all_results = []

for host in hosts:
    for keyword in keywords:
        results = perform_search(host, keyword)
        if results:
            all_results.append({
                'host': host,
                'keyword': keyword,
                'results': results['matches']
            })

# Save results to a file
with open('shodan_search_results.json', 'w') as f:
    json.dump(all_results, f, indent=4)

print('Results saved to shodan_search_results.json')

