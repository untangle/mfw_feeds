import unittest
from unittest.mock import MagicMock, patch
import requests
import sys 
import os
sys.path.append("../../../../../../dynamic-ip-blocker/files/")
sys.path.append("dynamic-ip-blocker/files")

from fetch_ip import FetchIp

class TestIPFetching(unittest.TestCase):

    def setUp(self):
        self.FetchIp = FetchIp()
        self.source_url = "http://opendbl.net/lists/etknown.list"
        self.mock_response = "127.0.0.1\n192.168.0.1\nnot_an_ip\n"

    def test_save_ips_to_file(self):
        ip_list = ["127.0.0.1", "192.168.0.1"]
        self.FetchIp.save_ips_to_file(ip_list, "ip_addresses.txt")
        with open("ip_addresses.txt", "r") as file:
            content = file.read()
            self.assertEqual(content, "127.0.0.1\n192.168.0.1")

    def test_is_valid_ip(self):
        self.assertTrue(self.FetchIp.is_valid_ip("192.168.0.1"))
        self.assertTrue(self.FetchIp.is_valid_ip("10.0.0.1"))
        self.assertFalse(self.FetchIp.is_valid_ip("not_an_ip"))

    #Mocking url response
    def test_fetch_ips_from_source_success(self):
        mock_get = MagicMock(return_value=MagicMock(status_code=200, text=self.mock_response))
        with patch('requests.get', mock_get):
            ip_list = self.FetchIp.fetch_ips_from_source(self.source_url)
            self.assertEqual(ip_list, ["127.0.0.1", "192.168.0.1"])

    def test_fetch_ips_from_source_error(self):
        mock_get = MagicMock(return_value=MagicMock(status_code=404))
        with patch('requests.get', mock_get):
            ip_list = self.FetchIp.fetch_ips_from_source(self.source_url)
            self.assertEqual(ip_list, [])


if __name__ == '__main__':
    unittest.main()


# Usage
# fetch = FetchIp()
# source_url = "http://opendbl.net/lists/etknown.list"
# ip_list = fetch.fetch_ips_from_source(source_url)
# print('ip_list')
# # print(ip_list)
# fetch.save_ips_to_file(ip_list, "dynamic_ip_addresses_list.txt")