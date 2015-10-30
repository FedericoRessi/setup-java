#!/bin/bash

source /etc/profile

set -ex

JAVA_VERSION=${JAVA_VERSION:-$1}

cd /vagrant

export JAVA=$(readlink -f $(which java))
find "$JAVA_HOME" -name java | grep "$JAVA"
[[ "$(basename $JAVA_HOME)" != "jre" ]]

source setup_java/setup_java.sh
test_java_version java $JAVA_VERSION
