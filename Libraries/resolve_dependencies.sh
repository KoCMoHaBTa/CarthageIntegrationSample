#!/bin/bash

#Use this script when in order to resolve all dependencies to the latest state, as defined in the Cartfile.resolved, when:
# - you have just downloaded the project and you are missing all dependencies
# - dependencies have been updated and you have old versions of them

#some vars
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LIB_DIR="$SCRIPT_DIR"

#importing /etc/paths
while read p; do
echo $p
export PATH=$p:$PATH
done < /etc/paths

#check if carthage is installed
if ! type "carthage" > /dev/null; then
>&2 echo "${BASH_SOURCE[0]}: line ${LINENO}: error: Carthage is required in order to resolve dependencies. Please install and add Carthage to /etc/paths"
exit 1
fi

#resolve dependencies
carthage checkout --project-directory $LIB_DIR

#configure dependencies
$LIB_DIR/configure_dependencies.rb

#copy the latest depencies state - used by check_dependencies.sh
touch $LIB_DIR/perform_dependency_check
cp $LIB_DIR/Cartfile.resolved $LIB_DIR/Cartfile.resolved.state
