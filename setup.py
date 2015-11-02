import os
import re
from setuptools import setup

# parse version from package/module without importing or evaluating the code
with open('setup_java/__init__.py') as fh:
    for line in fh:
        m = re.search(r"^__version__ = '(?P<version>[^']+)'$", line)
        if m:
            version = m.group('version')
            break

setup(
    name='setup-java',
    version=version,
    license='MIT',
    description='Bash script to setup java.',
    long_description=open(
        os.path.join(os.path.dirname(__file__), 'README.md')).read(),
    keywords='java',
    # url='https://github.com/todddeluca/python-vagrant',
    author='Federico Ressi',
    # author_email='federico.ressi@intel.com',
    classifiers=[
        'License :: OSI Approved :: Apache Software License',
        'Development Status :: 4 - Beta',
        'Programming Language :: Python :: 2',
        'Programming Language :: Python :: 2.7'],
    packages=['setup_java'], )
