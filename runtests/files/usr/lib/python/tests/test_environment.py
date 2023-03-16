"""environment for MFW tests"""
# pylint: disable=no-self-use
# pylint: disable=global-variable-not-assigned
import pytest

from tests.mfwtestcase import MFWTestCase
import runtests.remote_control as remote_control
import runtests.test_registry as test_registry

@pytest.mark.environment
class EnvironmentTests(MFWTestCase):
    """
    MFW environment tests
    """
    @staticmethod
    def module_name():
        return "environment"

    def test_10_client_connectivity(self):
        """verify connectivity to client"""
        assert remote_control.run_command("/bin/true") == 0

    def test_11_client_shell_return_code(self):
        """verify client can exec commands and return code"""
        assert remote_control.run_command("/bin/false") == 1

    def test_12_client_shell_output(self):
        """verify client can exec commands and return code"""
        result = remote_control.run_command("echo yay", stdout=True)
        assert result == "yay"

    def test_13_client_has_necessary_tools(self):
        """verify client has necessary tools"""
        # to configure client:
        # https://test.untangle.com/test/setup_testshell.sh
        assert remote_control.run_command("which wget") == 0
        assert remote_control.run_command("which curl") == 0
        assert remote_control.run_command("which netcat") == 0
        assert remote_control.run_command("which nmap") == 0
        assert remote_control.run_command("which python") == 0
        assert remote_control.run_command("which mime-construct") == 0
        assert remote_control.run_command("which pidof") == 0
        assert remote_control.run_command("which host") == 0
        assert remote_control.run_command("which upnpc") == 0
        assert remote_control.run_command("which traceroute") == 0
        # check for netcat options
        assert remote_control.run_command(r"netcat -h 2>&1 | grep -q '\-d\s'") == 0
        assert remote_control.run_command(r"netcat -h 2>&1 | grep -q '\-z\s'") == 0
        assert remote_control.run_command(r"netcat -h 2>&1 | grep -q '\-w\s'") == 0
        assert remote_control.run_command(r"netcat -h 2>&1 | grep -q '\-l\s'") == 0
        assert remote_control.run_command(r"netcat -h 2>&1 | grep -q '\-4\s'") == 0
        assert remote_control.run_command(r"netcat -h 2>&1 | grep -q '\-p\s'") == 0

    def test_14_client_is_online(self):
        """verify client is online"""
        assert remote_control.is_online() == 0

    def test_15_client_is_online_udp(self):
        """verify client can pass UDP"""
        timeout = 5
        result_cnn = 1
        result_google = 1
        while timeout > 0 and (result_cnn != 0 or result_google != 0):
            timeout -= 1
            result_cnn = remote_control.run_command("host cnn.com 8.8.8.8")
            result_google = remote_control.run_command("host google.com 8.8.8.8")

        assert result_cnn == 0
        assert result_google == 0

test_registry.register_module(EnvironmentTests.module_name(), EnvironmentTests)
