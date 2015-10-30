#!/bin/bash -e

source /vagrant/provision/etc/profile.d/*.sh

install_package rsync

# Copy configuration files
rsync -ua /vagrant/provision/* /
