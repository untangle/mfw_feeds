import collections
import json
import pytest
import runtests

from unittest import TestCase
from restd import Restd
from tests import LibUtilities

class MFWTestCase(TestCase):
    @staticmethod
    def vendorName():
        return "Arista"

    @staticmethod
    def module_name():
        """Return module name; to be implemented in subclasses."""

    @classmethod
    def initial_extra_setup(cls):
        """To be implemented in subclasses."""

    original_settings = None
    @classmethod
    def initial_setup(cls, unused=None):
        # the get settings API returns settings with authentication and other
        # items removed for privacy.
        # settings-export returns the full settings file but as a tarball
        export = Restd.get("/api/settings-export", return_type="content")
        cls.original_settings = json.loads(LibUtilities.untar_file(export, "/settings.json"), object_pairs_hook=collections.OrderedDict)

        cls.initial_extra_setup()

    @classmethod
    def final_extra_tear_down(cls):
        """To be implemented in subclasses."""

    @classmethod
    def final_tear_down(cls, unused=None):
        result = Restd.post("/api/settings", cls.original_settings)

        cls.final_extra_tear_down()

    @classmethod
    def setup_class(cls):
        cls.initial_setup()

    @classmethod
    def teardown_class(cls):
        cls.final_tear_down()
