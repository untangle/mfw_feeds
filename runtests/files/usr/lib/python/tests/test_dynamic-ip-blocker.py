import unittest
import requests
import sys 
import os
sys.path.append("../../../../../../dynamic-ip-blocker/files/")

from fetch_ip import FetchIp

class TestIPFetching(unittest.TestCase):
    def test_save_ips_to_file(self):
        ip_list = ["127.0.0.1", "192.168.0.1"]
        FetchIp.save_ips_to_file(ip_list, "ip_addresses.txt")
        with open("ip_addresses.txt", "r") as file:
            content = file.read()
            self.assertEqual(content, "127.0.0.1\n192.168.0.1")

    def test_is_valid_ip(self):
        self.assertTrue(FetchIp.is_valid_ip("192.168.0.1"))
        self.assertTrue(FetchIp.is_valid_ip("10.0.0.1"))
        self.assertFalse(FetchIp.is_valid_ip("not_an_ip"))


if __name__ == '__main__':
    unittest.main()


# Usage
# fetch = FetchIp()
# source_url = "http://opendbl.net/lists/etknown.list"
# ip_list = fetch.fetch_ips_from_source(source_url)
# print('ip_list')
# # print(ip_list)
# fetch.save_ips_to_file(ip_list, "dynamic_ip_addresses_list.txt")