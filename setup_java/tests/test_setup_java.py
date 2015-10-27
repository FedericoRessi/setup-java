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
        log_cm = vagrant.make_file_cm(log_file)

        vm = vagrant.Vagrant(
            root=path.dirname(__file__), out_cm=log_cm, err_cm=log_cm)
        print 'For details see log file: ', log_file
        try:

            self._destroy_vm(vm=vm, vm_name=vm_name)

            vm.up(vm_name=vm_name)
            vm._run_vagrant_command(
                ['ssh', vm_name, '-c',
                 '/vagrant/setup_java/tests/test_setup_java.sh ' +
                 java_version])
            vm.halt(vm_name=vm_name)

            vm.up(vm_name=vm_name)
            vm._run_vagrant_command(
                ['ssh', vm_name, '-c',
                 '/vagrant/setup_java/tests/test_setup_java_after_reboot.sh ' +
                 java_version])

        except BaseException:
            vm.suspend(vm_name=vm_name)
            with open(log_file, 'r') as f:
                for l in f:
                    sys.stderr.write(l)
            traceback.print_exc()
            raise

        else:
            self._destroy_vm(vm, vm_name)

    def _destroy_vm(self, vm, vm_name):
        # pylint: disable=no-member
        for vm_status in vm.status(vm_name=vm_name):
            if (vm_status.name == vm_name and
                    vm_status.state != 'not created'):
                vm.destroy(vm_name=vm_name)
                for vm_status in vm.status(vm_name=vm_name):
                    if (vm_status == vm_name and
                            vm_status.state != 'not created'):
                        self.fail('Unable to destroy existing VM.')


class TestSetupJava7(SetupJavaTestCase, unittest.TestCase):

    JAVA_VERSION = '7'


class TestSetupJava8(SetupJavaTestCase, unittest.TestCase):

    JAVA_VERSION = '8'
