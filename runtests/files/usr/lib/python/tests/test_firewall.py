import collections
import pytest

from tests.mfwtestcase import MFWTestCase
import runtests.test_registry as test_registry

from restd import Restd

@pytest.mark.mfw
class MFWFirewallTests(MFWTestCase):
    """
    MFW Firewall tests
    """
    @staticmethod
    def module_name():
        return "firewall"

    @staticmethod
    def create_rule(action="ACCEPT", description="_ats_rule", enabled=True, conditions=[{"op": "==", "type": "DESTINED_LOCAL","value": True}]):
        rule = {
            "action": {
                "type": f"{action}"
            },
            "conditions": conditions,
            "description": f"{description}",
            "enabled": enabled
        }
        return collections.OrderedDict(rule)
            
    def test_100_access_pass_verify(self):
        """
        Verify a valid rule passes and does not produce an error
        """
        rule = MFWFirewallTests.create_rule(conditions=[{
            "op": "==",
            "type": "DESTINED_LOCAL",
            "value": True
        },{
            "op": "==",
            "type": "SOURCE_ADDRESS",
            "value": "1.2.3.4"
        },{
            "op": "==",
            "port_protocol": 6,
            "type": "SOURCE_PORT",
            "value": "459-460"
        }])
        access_table = Restd.get("/api/settings/firewall/tables/access")
        access_table["chains"][0]["rules"].append(rule)
        result = Restd.post("/api/settings/firewall/tables/access", access_table)
        assert("error" not in result)

    # firewall rule fails verify
    def test_101_access_fail_verify(self):
        """
        Verify an invalid rule fails and produces an error
        """
        #
        # This will generate an nft rule like:
        # add rule inet access access-rules fib daddr type "local" ip saddr 1.2.3.4 tcp sport 459-460 udp sport 461 accep
        #
        # Which will return an error like:
        # Error: conflicting protocols specified: tcp vs. udp
        rule = MFWFirewallTests.create_rule(conditions=[{
            "op": "==",
            "type": "DESTINED_LOCAL",
            "value": True
        },{
            "op": "==",
            "type": "SOURCE_ADDRESS",
            "value": "1.2.3.4"
        },{
            "op": "==",
            "port_protocol": 6,
            "type": "SOURCE_PORT",
            "value": "459-460"
        },{
            "op": "==",
            "port_protocol": 17,
            "type": "SOURCE_PORT",
            "value": "461"
        }])
        access_table = Restd.get("/api/settings/firewall/tables/access")
        access_table["chains"][0]["rules"].append(rule)
        result = Restd.post("/api/settings/firewall/tables/access", access_table)
        print(result["error"])
        assert("error" in result and result["error"] != "")

test_registry.register_module(MFWFirewallTests.module_name(), MFWFirewallTests)
