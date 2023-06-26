import unittest
import requests

class TestIPFetching(unittest.TestCase):
    def test_save_ips_to_file(self):
        ip_list = ["127.0.0.1", "192.168.0.1"]
        save_ips_to_file(ip_list, "ip_addresses.txt")
        with open("ip_addresses.txt", "r") as file:
            content = file.read()
            self.assertEqual(content, "127.0.0.1\n192.168.0.1\n")

    def test_is_valid_ip(self):
        self.assertTrue(is_valid_ip("192.168.0.1"))
        self.assertTrue(is_valid_ip("10.0.0.1"))
        self.assertFalse(is_valid_ip("not_an_ip"))


if __name__ == '__main__':
    unittest.main()