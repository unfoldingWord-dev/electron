#!/bin/bash
set -e

# Example `./build_all_mac.sh electronite-v21.2.0-beta results`

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
    echo "Build Target already exists: $DEST_FILE"
else
    echo "Doing Build $TARGET"
    ./build_target_mac.sh $TARGET $DEST
fi

if [ -f $DEST_FILE ]; then
    echo "Target built: $DEST_FILE"
else
    echo "Target failed: $DEST_FILE"
    exit 10
fi

TARGET=arm64
DEST_FILE=$DEST/$TARGET/dist.zip
if [ -f $DEST_FILE ]; then
    echo "Build Target already exists: $DEST_FILE"
else
    echo "Doing Build $TARGET"
    ./build_target_mac.sh $TARGET $DEST
fi

if [ -f $DEST_FILE ]; then
    echo "Target built: $DEST_FILE"
else
    echo "Target failed: $DEST_FILE"
    exit 10
fi
