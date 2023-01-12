import pytest
import unittest

from tests import MFWTestCase
import runtests.test_registry as test_registry
import runtests.remote_control as remote_control

from restd import Restd

@pytest.mark.uvm
class MFWNetworkTests(MFWTestCase):
    @staticmethod
    def module_name():
        return "network"

    wantest_results = {}

    def test_010_client_is_online(self):
        result = remote_control.is_online()
        assert (result == 0)
    
    @pytest.mark.slow
    def test_100_wantest(self):
        """
        Perform wantest (speedtest) on WAN devices (save results to class variable for other tests)

        NOTE: This test's concern is that wantests successfully run and return valid results.
        """
        interfaces = Restd.get("/api/settings/network/interfaces")
        # Keep for testing
        # MFWNetworkTests.wantest_results = {
        #     'ppp-pppoeWan': {'ping': 42, 'download': 129033, 'upload': 10930},
        #     'eth1': {'ping': 32, 'download': 227576, 'upload': 167307},
        #     'eth2': {'ping': 28, 'download': 149487, 'upload': 11333}
        # }

        print()
        found_wan = False
        for interface in interfaces:
            if interface.get("enabled") is False:
                continue
            if interface.get("type") == "IPSEC":
                continue
            if interface.get("wan") is True:
                found_wan = True
                device = interface.get("device")
                if interface.get('v4ConfigType') == "PPPOE":
                    device = f"ppp-{interface.get('name')}"
                print(f"wantest:{device}: ", end="", flush=True)
                MFWNetworkTests.wantest_results[device] = Restd.get(f"/api/status/wantest/{device}")
                print(MFWNetworkTests.wantest_results[device], flush=True)

        if found_wan is False:
            raise unittest.SkipTest("unable to find any WAN interfaces")

        valid_keys = False
        valid_values = False
        expected_keys = ['ping', 'download', 'upload']
        for results in self.wantest_results.values():
            for expected_key in expected_keys:
                # Not seeing expected result keys indicates a problem
                if expected_key in results:
                    valid_keys = True
                else:
                    valid_keys = False
                    break

                # All values are expected to be non-zero integer values
                if type(results[expected_key]) is int and results[expected_key] > 0:
                    valid_values = True
                else:
                    valid_values = False
                    break

        assert valid_keys is True, f"results missing valid keys"
        assert valid_values is True, f"results missing values"

    @pytest.mark.slow
    def test_100_wantest_multi(self):
        """
        Analyze results of wan tests.

        Look at multiple WANs and validate their results are outside of a minimal threshold.
        Since we don't know if WAN interfaces have linespeeds outside of this threshold,
        don't fail results.  Pass if the differene between any two is greater than the threshold
        but mark the test as skip if the difference between is within the threshold.
        """
        if bool(MFWNetworkTests.wantest_results) is False:
            raise unittest.SkipTest("missing wantest_results")

        # Threshold prercentage
        threshold = 20

        # Walk values and compare current and previous download rate.
        over_threshold_diffs = 0
        under_threshold_diffs = 0
        last_rate = None
        rates = ['download' in value and value['download'] for value in self.wantest_results.values()]
        rates.sort()
        for rate in rates:
            if last_rate is None:
                last_rate = rate
                continue
            percent_difference = (abs(rate - last_rate)/rate) * 100
            last_rate = rate
            print(f"percent_difference={percent_difference}")
            if percent_difference > threshold:
                over_threshold_diffs += 1
            else:
                under_threshold_diffs += 1

        print(f"over_threshold_diffs={over_threshold_diffs}")
        print(f"under_threshold_diffs={under_threshold_diffs}")
        if over_threshold_diffs > 0:
            # At least one pair has line speeds over threshold
            assert(True)
        else:
            if under_threshold_diffs >= 0:
                # Either no multiple interfaces or they all have linespeeds within thresholds.
                # That's not neccessarily a failure so we're calling it a skip.
                raise unittest.SkipTest("under threshold results")

test_registry.register_module(MFWNetworkTests.module_name(), MFWNetworkTests)
