Command line tools to install Java 7 or Java 8 on a Linux host

# How to use

To install Java at given version (7 or 8) from bash type following:

```bash
git clone https://github.com/FedericoRessi/setup-java.git
cd setup-java
source setup_java/setup_java.sh
setup_java 8  # <- replace this with 7 if you requires it
```

# Supported Linux distributions

## Ubuntu
  - 14.04 LTS
  - 15.04
  - 15.10

## CentOS and RHEL
  - 7

## Fedora
  - 21
  - 22
  - 23


# Project background

The main original purpose of this project was testing works for solving this
issue:

[Bug # 1467949](https://bugs.launchpad.net/networking-odl/+bug/1467949)

I started working on a solution for the bug and this is the result:

[Change I145ee39aa8fd72d496e996e13af2338e9d240f07](https://review.openstack.org/#/c/218210/)

The core of that proposed code produced
[setup-java.sh](https://github.com/FedericoRessi/setup-java/blob/master/setup_java/setup_java.sh)
script that has been included on this project with the purpose of testing it
using Vagrant.

# How to test

## Tests requirements

- An Unix machine connected to Internet with at least 1GB of RAM
- Python: it should works with other releases, but not tested.
- [Pip](http://pip.readthedocs.org/en/stable/installing/)
- [Tox](https://tox.readthedocs.org/en/latest/)
- [Vagrant](https://www.vagrantup.com/)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- [GIT](https://git-scm.com/)

## Run tests

Clone this project and run Tox from the root project folder:

```bash
git clone https://github.com/FedericoRessi/setup-java.git
cd setup-java
tox
```

