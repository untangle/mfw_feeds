import time
import pytest
from unittest import TestCase

import runtests
from restd import Restd

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
        cls.original_settings = Restd.get("/api/settings-export")

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
