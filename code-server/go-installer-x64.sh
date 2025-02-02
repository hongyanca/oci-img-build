#!/bin/bash

#https://stackoverflow.com/questions/17480044/how-to-install-the-current-version-of-go-in-ubuntu-precise

## Define go official url
GO_URL='https://go.dev/dl/'

## Fetch stable versions of go
VERSION=1.23
BUILD=5
# Download the Go language downloads page
curl -o go-dev-dl.html $GO_URL
# Extract lines after the word 'Stable'
stable_info=$(grep -A4 'Stable' go-dev-dl.html)
# Extract the content of the `id` property from the div tag with the matching pattern
id_content=$(echo "$stable_info" | grep -oP 'id="\Kgo[0-9]+\.[0-9]+\.[0-9]+')
# Parse the extracted content to separate VERSION and BUILD
if [[ $id_content =~ go([0-9]+)\.([0-9]+)\.([0-9]+) ]]; then
  VERSION="${BASH_REMATCH[1]}.${BASH_REMATCH[2]}"
  BUILD="${BASH_REMATCH[3]}"
else
  echo "Unable to extract Go version information"
  rm go-dev-dl.html
  exit 1
fi
# Clean up
rm go-dev-dl.html

## Define package name
PKG_NAME='go'

## Define local path
LOCAL_PATH='/usr/local'

## Define system library path
LIB_PATH='/usr/lib'

## Define system binary path
BIN_PATH='/usr/bin'

## Define EV script filename
EV_FILE='/etc/profile.d/go-bin-path.sh'

## Defile export path command
EXPORT_CMD='export PATH=$PATH:/usr/local/go/bin'

## Define script content
SCRIPT='#!/bin/sh\n'${EXPORT_CMD}

## Define user home dir
USER_HOME_DIR=$(getent passwd ${SUDO_USER:-$USER} | cut -d: -f6)

check_command() {
  [ -x "$(command -v $PKG_NAME)" ] && echo 0 || echo 1
}

test_package() {
  echo
  code=$(check_command)
  [ $code -eq 0 ] && go version || echo "Error: $PKG_NAME is not installed." >&2
  exit $code
}

is_sudoer() {
  ## Define error code
  E_NOTROOT=87 # Non-root exit error.

  ## check if is sudoer
  if ! $(sudo -l &>/dev/null); then
    echo 'Error: root privileges are needed to run this script'
    return $E_NOTROOT
  fi
  return 0
}

if is_sudoer; then
  ## Remove previous package versions
  status="$(dpkg-query -W --showformat='${db:Status-Status}' ${PKG_NAME} 2>&1)"
  if [ $? = 0 ] || [ "${status}" = installed ]; then
    sudo apt remove --purge --auto-remove -y "${PKG_NAME}"
  fi

  pkg_path="${LOCAL_PATH}/go"
  pkg_lib_path="${LIB_PATH}/go"

  ## Download the latest version available.
  # [ "$BUILD" -eq "0" ] && version_build="${VERSION}" || version_build="${VERSION}.${BUILD}"
  version_build="${VERSION}.${BUILD}"
  mkdir "${USER_HOME_DIR}/tmp"
  cd "${USER_HOME_DIR}/tmp"
  wget "${GO_URL}go${version_build}.linux-amd64.tar.gz"

  ## Extract and install the downloaded version
  if [ -f "go${version_build}.linux-amd64.tar.gz" ]; then
    sudo rm -rf "${pkg_path}" && sudo tar -xzvf "go${version_build}.linux-amd64.tar.gz" -C "${LOCAL_PATH}"

    ## Add symbolic link binary files to system binary and library directories
    if [ ! -h "${pkg_lib_path}" ]; then
      sudo ln -sv "${pkg_path}" "${pkg_lib_path}"
    fi

    binaries='go gofmt'
    for i in $binaries; do
      if [ ! -h "${BIN_PATH}/${i}" ]; then
        sudo ln -sv "${pkg_lib_path}/bin/${i}" "${BIN_PATH}/${i}"
      fi
    done

    ## Test your new version.
    test_package
  else
    echo "Error: tar file does not exits." >&2
    exit 1
  fi
else
  exit $?
fi
