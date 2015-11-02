#!/usr/bin/python

from os import path
import subprocess
import sys


def main(argv):
    package_dir = path.dirname(__file__)
    distrib_properties_script = path.join(package_dir, 'setup_java.sh')
    setup_java_script = path.join(package_dir, 'setup_java.sh')
    command = 'source "{}" "{}"; setup_java "{}"'.format(
        distrib_properties_script, setup_java_script, '" "'.join(argv))
    subprocess.call(('/bin/bash', '-c', command,))


if __name__ == '__main__':
    main(argv=sys.argv[1:])
