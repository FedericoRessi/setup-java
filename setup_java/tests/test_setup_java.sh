#!/bin/bash

set -ex

JAVA_VERSION=${JAVA_VERSION:-$1}

if apt-get --version > /dev/null; then
    function is_ubuntu {
        return 0
    }

else
    function is_ubuntu {
        return 1
    }

fi

cd /vagrant

source setup_java/setup_java.sh

setup_java $JAVA_VERSION 
test_java_version java $JAVA_VERSION
[[ "$JAVA" == "$(realpath $(which java))" ]]
find "$JAVA_HOME" -name java | grep "$JAVA"
[[ "$(basename $JAVA_HOME)" != "jre" ]]
