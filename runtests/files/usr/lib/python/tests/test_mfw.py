import pytest
import re
import unittest

from tests.mfwtestcase import MFWTestCase
import runtests.test_registry as test_registry
import runtests.remote_control as remote_control

from restd import Restd

@pytest.mark.mfw
class MFWBaseTests(MFWTestCase):
    """
    General MFW tests
    """
    @staticmethod
    def module_name():
        return "mfw"

    def test_010_client_is_online(self):
        """
        Verify client is online
        """
        result = remote_control.is_online()
        assert (result == 0)

    def test_020_about_info(self):
        uid = Restd.get_string("/api/status/uid")
        match = re.search(r'\w{8}-\w{4}-\w{4}.\w{4}.\w{12}', uid)
        assert( match )

    def test_100_command_account(self):
        account = Restd.get("/api/status/command/find_account")
        if account["account"] is None:
            raise unittest.SkipTest('Skipping no accound found')
        else:
            assert(True)

test_registry.register_module(MFWBaseTests.module_name(), MFWBaseTests)
