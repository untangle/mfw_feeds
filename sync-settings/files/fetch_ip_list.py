import requests
import ipaddress
import sys

class FetchIpList:
    """
    A class for fetching and storing IP addresses from a given source URL.
    """
    
    def is_valid_ip(self, ip):
        """
        Check if the provided IP address is valid.
        Args: ip (str): IP address to validate.
        """
        try:
            ipaddress.ip_address(ip)
            return True
        except ValueError:
            return False

    def fetch_ips_from_source(self, source_url):
        """
        Fetches a list of IP addresses from the provided source URL and validates them.
        Args: source_url (str): URL of the source containing IP addresses.
        """
        try:
            response = requests.get(source_url)
            ip_addresses = []
            if response.status_code == 200:
                ip_addresses_response = response.text.split('\n')
                for ip in ip_addresses_response:
                    ip = ip.strip()
                    if self.is_valid_ip(ip):
                        ip_addresses.append(ip)
                return ip_addresses
            else:
                print(f"Error fetching IP addresses. Status Code: {response.status_code}")
        except requests.exceptions.RequestException as e:
            sys.stderr.write(f"Error fetching IP addresses: {e}")
        return []

    def save_ips_to_file(self, ip_list, file_path):
        """
        Saves the provided list of IP addresses to a file.
        Args:
            ip_list (list): List of IP addresses to save.
            file_path (str): Path of the file to save the IP addresses.
        """
        try:
            with open(file_path, 'w') as file:
                file.write('\n'.join(ip_list))
            print(f"IP addresses saved to {file_path}")
        except IOError as e:
            sys.stderr.write(f"Error saving IP addresses to file: {e}")

def main():
    fetch = FetchIpList()
    if len(sys.argv) != 3:
        print('Usage: python script.py <source_url> <file_path>')
        sys.exit(1)
    # Example source_url = "http://opendbl.net/lists/etknown.list"
    source_url = sys.argv[1]
    file_path = sys.argv[2]
    ip_list = fetch.fetch_ips_from_source(source_url)
    if(ip_list):
        fetch.save_ips_to_file(ip_list, file_path)

if __name__ == "__main__":
    main()