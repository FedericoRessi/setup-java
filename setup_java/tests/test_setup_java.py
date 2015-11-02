#!/usr/bin/python

import contextlib
import datetime
import os
from os import path
import sys
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

        with self._create_vm(vm_name) as vm:
            vm.up(vm_name=vm_name)

            # execute setup java
            vm._call_vagrant_command(
                ['ssh', vm_name, '-c',
                 '/vagrant/setup_java/tests/test_setup_java.sh ' +
                 java_version])

            # reboot
            vm.halt(vm_name=vm_name)
            vm.up(vm_name=vm_name)

            # verify environment after reboot
            vm._call_vagrant_command(
                ['ssh', vm_name, '-c',
                 '/vagrant/setup_java/tests/test_setup_java_after_reboot.sh ' +
                 java_version])

    @contextlib.contextmanager
    def _create_vm(self, vm_name):
        # pylint: disable=broad-except

        with self._get_log_context_manager() as log_context_manager:
            vm = vagrant.Vagrant(
                root=path.dirname(__file__), out_cm=log_context_manager,
                err_cm=log_context_manager)

            try:
                self._destroy_vm(vm=vm, vm_name=vm_name)

                yield vm

            except BaseException:
                try:
                    vm.suspend(vm_name=vm_name)

                except Exception:
                    traceback.print_exc()

                raise

            else:
                try:
                    self._destroy_vm(vm, vm_name)

                except Exception:
                    traceback.print_exc()

    @contextlib.contextmanager
    def _get_log_context_manager(self, mode='a'):
        # pylint: disable=no-member
        log_timestamp = datetime.datetime.now().isoformat()
        if not path.isdir('logs'):
            os.mkdir('logs')
        log_file_name = path.join(
            'logs', '{}-{}.log').format(log_timestamp, self.id())

        sys.stderr.write(
            '\nFor details read log file: {}\n'.format(log_file_name))

        log_fd = open(log_file_name, mode=mode)
        self.addCleanup(log_fd.close)

        @contextlib.contextmanager
        def log_context_manager():
            yield log_fd

        try:
            yield log_context_manager

        except Exception:
            log_fd.flush()
            with open(log_file_name, 'r') as f:
                for l in f:
                    sys.stderr.write(l)
            traceback.print_exc()
            raise

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
