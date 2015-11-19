#!/bin/bash

source /etc/profile

set -ex

JAVA_VERSION=${JAVA_VERSION:-$1}

cd /vagrant

source setup_java/setup_java.sh

setup_java $JAVA_VERSION

test_java_version java $JAVA_VERSION

setup_java_env

[[ "$JAVA" == "$(readlink -f $(which java))" ]]
find "$JAVA_HOME" -name java | grep "$JAVA"
[[ "$(basename $JAVA_HOME)" != "jre" ]]

echo $0": SUCCESS"

