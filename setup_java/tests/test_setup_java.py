#!/usr/bin/python

from os import path
import unittest

import vagrant


class SetupJavaTestCase(unittest.TestCase):

    JAVA_VERSION = None

    def test_setup_java_on_ubuntu_trusty(self):
        self._test_setup_java(
            java_version=self.JAVA_VERSION, vm_name="trusty")

    def test_setup_java_on_ubuntu_vivid(self):
        self._test_setup_java(
            java_version=self.JAVA_VERSION, vm_name="vivid")

    def test_setup_java_on_fedora_21(self):
        self._test_setup_java(
            java_version=self.JAVA_VERSION, vm_name="fedora21")

    def test_setup_java_on_fedora_22(self):
        self._test_setup_java(
            java_version=self.JAVA_VERSION, vm_name="fedora22")

    def test_setup_java_on_centos_7(self):
        self._test_setup_java(
            java_version=self.JAVA_VERSION, vm_name="centos7")

    def _test_setup_java(self, java_version, vm_name):
        vm = vagrant.Vagrant(path.dirname(__file__))
        vm.up(vm_name=vm_name)
        # pylint: disable=protected-access
        vm._run_vagrant_command(
            ['ssh', vm_name, '-c',
             '/vagrant/setup_java/tests/test_setup_java.sh', java_version])


class TestSetupJava7(SetupJavaTestCase):

    JAVA_VERSION = '7'


class TestSetupJava8(SetupJavaTestCase):

    JAVA_VERSION = '8'
