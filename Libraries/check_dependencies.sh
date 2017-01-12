#!/bin/bash

#Use this script to check if dependencies needs to be updated
#exit codes:
# 0 - OK
# 1 - Missing dependency state
# 2 - Dependencies changed

#some vars
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LIB_DIR="$SCRIPT_DIR"

#check if dependency check should be executed - it is not nececary when running from CI/CD tool
if [ ! -f $LIB_DIR/perform_dependency_check ]; then

    exit 0
fi

#check if there is no sha calculated for Cartfile.resolved.state - this usually happens when the repository is freshly cloned
if [ ! -f $LIB_DIR/Cartfile.resolved.state ]; then

    echo "${BASH_SOURCE[0]}:${LINENO}: error: Missing dependency state - you must resolve dependencies first."
    exit 1
fi

#calcualte sha of Cartfile.resolved.state
CARTFILE_RESOLVED_STATE_SHA=$(openssl sha1 $LIB_DIR/Cartfile.resolved.state | awk '{print $2}')

#calcualte sha of Cartfile.resolved
CARTFILE_RESOLVED_SHA=$(openssl sha1 $LIB_DIR/Cartfile.resolved | awk '{print $2}')

#check if the sha calculated for Cartfile.resolved.state differs from the Cartfile.resolved - this usually hapens when dependencies were changed
if [ "$CARTFILE_RESOLVED_STATE_SHA" != "$CARTFILE_RESOLVED_SHA" ]; then

    echo "${BASH_SOURCE[0]}:${LINENO}: error: Dependencies changed - you must resolve dependencies."
    exit 2
fi

#everything is just fine
exit 0
