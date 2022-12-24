#!/bin/bash
set -e

# Meta Build script to get sources, and then build for x64 and arm64 by calling build_target_mac.sh
#     for each architecture.  The dist.zip files are stored at $DEST
#
# to troubleshoot build problems, do build logging by doing `export BUILD_EXTRAS=-vvvvv` before running
#
# Example `./build_all_mac.sh electronite-v21.3.3-beta results/mac/v21.3.3`

BRANCH=$1
DEST=$2

echo "Building $BRANCH to: $DEST"

if [ ! -d src ]; then
    echo "Getting sources from $BRANCH"
    ./electronite-tools-3.sh get $BRANCH
fi

TARGET=x64
DEST_FILE=$DEST/$TARGET/dist.zip
if [ -f $DEST_FILE ]; then
    echo "Build $TARGET already exists: $DEST_FILE"
else
    echo "Doing Build $TARGET"
    ./build_target_mac.sh $TARGET $DEST
fi

if [ -f $DEST_FILE ]; then
    echo "Distribution $TARGET built: $DEST_FILE"
else
    echo "Distribution $TARGET failed: $DEST_FILE"
    exit 10
fi

TARGET=arm64
DEST_FILE=$DEST/$TARGET/dist.zip
if [ -f $DEST_FILE ]; then
    echo "Build $TARGET already exists: $DEST_FILE"
else
    echo "Doing Build $TARGET"
    ./build_target_mac.sh $TARGET $DEST
fi

if [ -f $DEST_FILE ]; then
    echo "Distribution $TARGET built: $DEST_FILE"
else
    echo "Distribution $TARGET failed: $DEST_FILE"
    exit 10
fi

echo "All builds completed to $DEST"
