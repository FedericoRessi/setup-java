#!/bin/bash

set -ex

JAVA_VERSION=${JAVA_VERSION:-$1}

if which apt-get > /dev/null; then
    function is_ubuntu {
        return 0
    }

else
    function is_ubuntu {
        return 1
    }

fi

cd /vagrant

export JAVA=$(readlink -f $(which java))
find "$JAVA_HOME" -name java | grep "$JAVA"
[[ "$(basename $JAVA_HOME)" != "jre" ]]

source setup_java/setup_java.sh
test_java_version java $JAVA_VERSION
