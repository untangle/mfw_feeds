import collections
import copy
import pytest

from tests import MFWTestCase, LibCommands, LibFirewall
import runtests.test_registry as test_registry
import runtests.remote_control as remote_control

from restd import Restd

@pytest.mark.mfw
class MFWFirewallTests(MFWTestCase):
    """
    MFW Firewall tests
    """
    @staticmethod
    def module_name():
        return "firewall"

    def test_100_access_pass_verify(self):
        """
        Verify a valid rule passes and does not produce an error
        """
        rule = LibFirewall.create_rule(
            action="ACCEPT",
            conditions=[
                LibFirewall.create_condition(type="DESTINED_LOCAL", value=True),
                LibFirewall.create_condition(type="SOURCE_ADDRESS", value="1.2.3.4"),
                LibFirewall.create_condition(type="SOURCE_PORT", value="459-460", port_protocol=6)
            ]
        )
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
        rule = LibFirewall.create_rule(
            action="ACCEPT",
            conditions=[
                LibFirewall.create_condition(type="DESTINED_LOCAL", value=True),
                LibFirewall.create_condition(type="SOURCE_ADDRESS", value="1.2.3.4"),
                LibFirewall.create_condition(type="SOURCE_PORT", value="459-460", port_protocol=6),
                LibFirewall.create_condition(type="SOURCE_PORT", value="461", port_protocol=17)

            ]
        )
        access_table = Restd.get("/api/settings/firewall/tables/access")
        access_table["chains"][0]["rules"].append(rule)
        result = Restd.post("/api/settings/firewall/tables/access", access_table)
        print(result["error"])
        assert("error" in result and result["error"] != "")

    @classmethod
    def accept_reject_rules_traffic(cls, table="filter", accept_rule=None, accept_uris=["https://www.facebook.com"], reject_uris=["https://www.youtube.com"]):
        """
        Perform test with two rules: One for acceptable traffic and another for non-acceptable traffic via wget.
        """
        api_table_path= f"/api/settings/firewall/tables/{table}"
        original_table = copy.deepcopy(Restd.get(api_table_path))

        table = copy.deepcopy(original_table)
        table.get("chains")[0]["rules"] = []
        if accept_rule is not None:
            table.get("chains")[0]["rules"].append(accept_rule)
        table.get("chains")[0]["rules"].append(LibFirewall.create_rule(action="REJECT"))
        result = Restd.post(api_table_path, table)
        error = result.get("error")
        if error is not None:
            # Error from sync-settings
            print(f"cannot add rules: {error}")
            assert(False)

        error_message = None
        all_pass = True
        try:
            for uri in accept_uris:
                result = remote_control.run_command(LibCommands.wget(uri=uri))
                assert result == 0, f"accept failed for {uri}"

            for uri in reject_uris:
                result = remote_control.run_command(LibCommands.wget(uri=uri, tries=1, timeout=.5))
                assert result != 0, f"reject failed for {uri}"
        except AssertionError as error_message:
            # Always want to run the rule restore
            print(error_message)
            all_pass = False
            pass

        Restd.post(api_table_path, original_table)
        assert all_pass is True

    def test_200_filter_application_name(self):
        MFWFirewallTests.accept_reject_rules_traffic(
            accept_rule=LibFirewall.create_rule(action="ACCEPT", conditions=[LibFirewall.create_condition(type="APPLICATION_NAME", value="Facebook")])
        )

    def test_201_filter_application_name_inferred(self):
        MFWFirewallTests.accept_reject_rules_traffic(
            accept_rule=LibFirewall.create_rule(action="ACCEPT", conditions=[LibFirewall.create_condition(type="APPLICATION_NAME_INFERRED", value="Facebook")])
        )

    def test_202_filter_application_id(self):
        MFWFirewallTests.accept_reject_rules_traffic(
            accept_rule=LibFirewall.create_rule(action="ACCEPT", conditions=[LibFirewall.create_condition(type="APPLICATION_ID", value="FACEBOOK")])
        )

    def test_203_filter_application_id_inferred(self):
        MFWFirewallTests.accept_reject_rules_traffic(
            accept_rule=LibFirewall.create_rule(action="ACCEPT", conditions=[LibFirewall.create_condition(type="APPLICATION_ID_INFERRED", value="FACEBOOK")])
        )

    def test_204_filter_application_category(self):
        MFWFirewallTests.accept_reject_rules_traffic(
            accept_rule=LibFirewall.create_rule(action="ACCEPT", conditions=[LibFirewall.create_condition(type="APPLICATION_CATEGORY", value="Social Networking")])
        )

    def test_205_filter_application_category_inferred(self):
        MFWFirewallTests.accept_reject_rules_traffic(
            accept_rule=LibFirewall.create_rule(action="ACCEPT", conditions=[LibFirewall.create_condition(type="APPLICATION_CATEGORY_INFERRED", value="Social Networking")])
        )

    def test_206_filter_application_productivity(self):
        MFWFirewallTests.accept_reject_rules_traffic(
            accept_rule=LibFirewall.create_rule(action="ACCEPT", conditions=[LibFirewall.create_condition(type="APPLICATION_PRODUCTIVITY", value=2)])
        )

    def test_207_filter_application_productivity_inferred(self):
        MFWFirewallTests.accept_reject_rules_traffic(
            accept_rule=LibFirewall.create_rule(action="ACCEPT", conditions=[LibFirewall.create_condition(type="APPLICATION_PRODUCTIVITY_INFERRED", value=2)])
        )

    def test_208_filter_application_risk(self):
        MFWFirewallTests.accept_reject_rules_traffic(
            accept_rule=LibFirewall.create_rule(action="ACCEPT", conditions=[LibFirewall.create_condition(type="APPLICATION_RISK", value=5)])
        )

    def test_209_filter_application_risk_inferred(self):
        MFWFirewallTests.accept_reject_rules_traffic(
            accept_rule=LibFirewall.create_rule(action="ACCEPT", conditions=[LibFirewall.create_condition(type="APPLICATION_RISK_INFERRED", value=5)])
        )

# Remaining tests to add:
# Filter
# Client Address
# Client Address v6
# Client Port
# Client Interface Zone
# Client Interface Type
# Client Reverse DNS
# Server Address
# Server Address v6
# Server Port
# Server Interface Zone
# Server Interface Type
# Server DNS Hint
# Cert Subject Common Name
# Cert Subject Organization
# Cert Subject DNS Names
# IP Protocol

# Shaping - NETWORK
# Application Name
# Application Category
# Application ID
# Application Productivity
# Application Risk
# Client Address
# Client Address v6
# Client Port
# Client Interface Zone
# Client Interface Type
# Client Reverse DNS
# Server Address
# Server Address v6
# Server Port
# Server Interface Zone
# Server Interface Type
# Server DNS Hint
# Cert Subject Common Name
# Cert Subject Organization
# Cert Subject DNS Names
# IP Protocol

# NAT - NETWORK
# Application Name
# Application Category
# Application ID
# Application Productivity
# Application Risk
# Source Address
# Source Address type
# Source Port
# Source interface name
# Source Interface Zone
# Source Interface Type
# Destination Address
# Destination Address v6
# Destination Port
# Destination Local
# Server DNS Hint
# Cert Subject Common Name
# Cert Subject Organization
# Cert Subject DNS Names
# IP Protocol

#
# Access
# Source Address
# Source Address v6
# Source Address type
# Source Port
# Source interface name
# Source Interface Zone
# Source Interface Type
# Destination Address
# Destination Address v6
# Destination Port
# Destination Local
# IP Protocol
#
# Port Forward - NETWORK
# Access
# Source Address
# Source Address v6
# Source Address type
# Source Port
# Source interface name
# Source Interface Zone
# Source Interface Type
# Destination Address
# Destination Address v6
# Destination Port
# Destination Local


test_registry.register_module(MFWFirewallTests.module_name(), MFWFirewallTests)
