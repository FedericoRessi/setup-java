#!/usr/bin/python

import os
from os import path
import sys
import tempfile
import traceback
import unittest

import vagrant


class SetupJavaTestCase(object):

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
        # pylint: disable=protected-access
        # pylint: disable=no-member
        log_file = tempfile.mktemp()
        self.addCleanup(lambda: os.remove(log_file))
        print 'For details see log file: ', log_file
        try:
            log_cm = vagrant.make_file_cm(log_file)
            vm = vagrant.Vagrant(
                root=path.dirname(__file__), out_cm=log_cm, err_cm=log_cm)
            self.addCleanup(lambda: vm.destroy(vm_name=vm_name))
            vm.up(vm_name=vm_name)
            vm._run_vagrant_command(
                ['ssh', vm_name, '-c',
                 '/vagrant/setup_java/tests/test_setup_java.sh ' +
                 java_version])

        except Exception:
            with open(log_file, 'r') as f:
                for l in f:
                    sys.stderr.write(l)
            traceback.print_exc()
            raise


class TestSetupJava7(SetupJavaTestCase, unittest.TestCase):

    JAVA_VERSION = '7'


class TestSetupJava8(SetupJavaTestCase, unittest.TestCase):

    JAVA_VERSION = '8'
