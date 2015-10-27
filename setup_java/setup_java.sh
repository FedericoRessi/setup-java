#!/bin/bash

function setup_java {
    local VERSION="$1"
    if [[ "$VERSION" == "" ]]; then
        # It should be OK in most of the cases
        VERSION=7
    fi

    echo "Setup Java version: $VERSION"
    if test_java_version java "$VERSION"; then
        echo "Current Java version is already $VERSION."

    elif select_java "$VERSION"; then
        echo "Java version $VERSION has been selected."

    elif install_openjdk "$VERSION" && select_java "$VERSION"; then
        echo "OpenJDK version $VERSION has been installed and selected."

    elif install_other_java "$VERSION" && select_java "$VERSION"; then
        echo "Some Java version $VERSION has been installed and selected."

    else
        echo "ERROR: Unable to setup Java version $VERSION."
        return 1
    fi

    if ! setup_java_env; then
        echo "ERROR: Unable to setup java $VERSION enviroment."
    fi

    return 0
}

function setup_java_env() {
    local JAVA_COMMAND="$1"
    if [[ "$JAVA_COMMAND" == "" ]]; then
        JAVA_COMMAND="java"
    fi

    JAVA_LINK="$(which $JAVA_COMMAND)"
    if [[ "$JAVA_LINK" == "" ]]; then
        return 1
    fi

    export JAVA="$(readlink -f $JAVA_LINK)"
    export JAVA_HOME=$(echo $JAVA | sed "s:/bin/java::" | sed "s:/jre::")

    if ! grep "export JAVA_HOME=${JAVA_HOME}" /etc/profile.d/*; then
        # make JAVA_HOME variables persistent
        local ENV_FILE="$(mktemp)"
        echo "export JAVA_HOME=${JAVA_HOME}" > ${ENV_FILE}
        sudo mv "$ENV_FILE" /etc/profile.d/z99-java.sh
    fi

    echo "JAVA is: $JAVA"
    echo "JAVA_HOME is: $JAVA_HOME"
    echo "Java version is:"
    $JAVA -version 2>&1

    return 0
}

function select_java {
    local VERSION="$1"
    local COMMAND

    for COMMAND in $(list_java_commands); do
        if test_java_version "$COMMAND" "$VERSION"; then
            if select_installed_java_command "$COMMAND"; then
                if test_java_version java "$VERSION"; then
                    return 0
                fi
            fi
        fi
    done

    return 1
}

function test_java_version {
    local COMMAND="$1"
    local VERSION="$2"

    $COMMAND -version 2>&1 | grep -q 'version "1\.'$VERSION'\..*"'
}

if is_ubuntu; then
    # --- Ubuntu -------------------------------------------------------------

    function list_java_commands {
        update-alternatives --list java
    }

    function select_installed_java_command {
        sudo update-alternatives --set java "$1"
    }

    function install_openjdk {
        local REQUIRED_VERSION="$1"
        sudo apt-get install -y "openjdk-$REQUIRED_VERSION-jre-headless"
    }

    function install_other_java {
        local VERSION="$1"
        local PPA_REPOSITORY="ppa:webupd8team/java"
        local JAVA_INSTALLER="oracle-java${VERSION}-installer"
        local JAVA_PACKAGES="${JAVA_INSTALLER} oracle-java${VERSION}-set-default"

        # Accept installer license
        echo "$JAVA_INSTALLER" shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections

        if sudo apt-get install -y "$JAVA_PACKAGES" ; then
            return 0
        fi

        # Add PPA only when package is not available
        if sudo apt-get install -y software-properties-common; then
            if echo | sudo add-apt-repository "$PPA_REPOSITORY"; then
                if sudo apt-get update && sudo apt-get install -y "$JAVA_PACKAGES"; then
                    return 0
                fi
            fi
        fi

        return 1
    }

else
    # --- Fedora -------------------------------------------------------------

    function list_java_commands {
         alternatives --display java 2>&1 | grep -v '^[[:space:]]' | awk '/[[:space:]]- priority[[:space:]]/{print $1}'
    }

    function install_openjdk {
        local VERSION="$1"
        sudo yum install -y java-1.$VERSION.*-openjdk-headless
    }

    function install_other_java {
        local VERSION="$1"

        if [[ "$(uname -m)" == "x86_64" ]]; then
            local ARCH=linux-x64
        else
            local ARCH=linux-i586
        fi

        if [[ "$VERSION" == 7 ]]; then

            local ORIGIN="7u80-b15/jdk-7u80"
            local TARGET="jdk1.7.0_80"

        elif [[ "$VERSION" == 8 ]]; then
            local ORIGIN="8u60-b27/jdk-8u60"
            local TARGET="jdk1.8.0_60"

        else
            echo "Unsupported Java version: $VERSION."
            return 1
        fi

        local NEW_JAVA="/usr/java/$TARGET/jre/bin/java"
        if test_java_version "$NEW_JAVA" "$VERSION"; then
            if sudo alternatives --install /usr/bin/java java "$NEW_JAVA" 200000; then
                return 0
            fi
        fi

        local EXT
        local WGET_OPTIONS="-c --no-check-certificate --no-cookies"
        local HEADER="Cookie: oraclelicense=accept-securebackup-cookie"

        for EXT in "rpm" "tar.gz"; do
            local URL="http://download.oracle.com/otn-pub/java/jdk/$ORIGIN-$ARCH.$EXT"
            local PACKAGE="/tmp/$(basename $URL)"

            if wget $WGET_OPTIONS --header "$HEADER" "$URL" -O "$PACKAGE"; then
                case "$EXT" in
                    "rpm")
                        sudo rpm -i $PACKAGE
                        ;;
                    "tar.gz")
                        sudo mkdir -p /usr/java && sudo tar -C /usr/java -xzf "$PACKAGE"
                        ;;
                    *)
                        echo "Unsupported extension: $EXT"
                        ;;
                esac

                if test_java_version "$NEW_JAVA" "$VERSION"; then
                    if sudo alternatives --install /usr/bin/java java "$NEW_JAVA" 200000; then
                        return 0
                    fi
                fi

                echo "Unable to register installed java."

            else
                echo "Unable to download java archive: $URL"
            fi

        done

        return 1
    }

    function select_installed_java_command {
        sudo alternatives --set java "$1"
    }
fi
