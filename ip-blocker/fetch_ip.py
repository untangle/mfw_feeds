import requests
import ipaddress

def is_valid_ip(ip):
    try:
        ipaddress.ip_address(ip)
        return True
    except ValueError:
        return False

def fetch_ips_from_source(source_url):
    try:
        response = requests.get(source_url)
        ip_addresses = []
        if response.status_code == 200:
            ip_addresses_response = response.text.split('\n')
            for ip in ip_addresses_response:
                ip = ip.strip()
                if is_valid_ip(ip):
                    ip_addresses.append(ip)
            return ip_addresses
        else:
            print(f"Error fetching IP addresses. Status Code: {response.status_code}")
    except requests.exceptions.RequestException as e:
        print(f"Error fetching IP addresses: {e}")
    return []

def save_ips_to_file(ip_list, file_path):
    try:
        file = open(file_path, 'w')
        # for ip in ip_list:
        #     file.write(ip + '\n')
        file.write('\n'.join(ip_list))
        print(f"IP addresses saved to {file_path}")
        file.close()
    except IOError as e:
        print(f"Error saving IP addresses to file: {e}")


# Usage
source_url = "http://opendbl.net/lists/etknown.list"
ip_list = fetch_ips_from_source(source_url)
print('ip_list')
print(ip_list)
save_ips_to_file(ip_list, "/path_to_dir/ip_addresses.txt")
