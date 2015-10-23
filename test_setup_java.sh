#!/bin/bash

JAVA_VERSION=${JAVA_VERSION:$1}

set -ex

if apt-get --version; then
    function is_ubuntu {
        return 0
    }

else
    function is_ubuntu {
        return 1
    }

fi

cd /vagrant

if ! cd networking-odl; then
    git clone http://git.openstack.org/openstack/networking-odl -b master
    cd networking-odl
    git fetch http://review.openstack.org/openstack/networking-odl refs/changes/10/218210/18
    git rebase origin/master FETCH_HEAD
    git checkout -b bug/1467949
fi

source devstack/setup_java.sh

setup_java $JAVA_VERSION 
test_java_version java $JAVA_VERSION
[[ "$JAVA" == "$(realpath $(which java))" ]]
find "$JAVA_HOME" -name java | grep "$JAVA"
[[ "$(basename $JAVA_HOME)" != "jre" ]]
