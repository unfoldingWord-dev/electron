#!/bin/bash
set -e

rem Example `./build_target_mac.sh x64 results`

TARGET=$1
DEST=$2

echo "Building $TARGET to: $DEST"

BUILD_TARGET=./src/out/Release-$TARGET/Electron.app
if [ -f "$BUILD_TARGET" ]; then
    echo "Build Target already exists: $BUILD_TARGET"
else
    echo "Doing Build $TARGET"
    ./electronite-tools-3.sh build $TARGET
fi

if [ -f "$BUILD_TARGET" ]; then
    echo "Target built: $BUILD_TARGET"
else
    echo "Target failed: $BUILD_TARGET"
    exit 1
fi

RELEASE_TARGET=./src/out/Release-$TARGET/dist.zip
if [ -f "$RELEASE_TARGET" ]; then
    echo "Release Target already exists: $RELEASE_TARGET"
else
    echo "Doing Release $TARGET"
    ./electronite-tools-3.sh release $TARGET
fi

if [ -f "$RELEASE_TARGET" ]; then
    echo "Target released: $RELEASE_TARGET"
else
    echo "Target failed: $RELEASE_TARGET"
    exit 1
fi


DEST_FILE=$DEST/$TARGET/dist.zip
echo "Copy from $RELEASE_TARGET to $DEST_FILE"
cp $RELEASE_TARGET $DEST_FILE

TARGET_FOLDER=$DEST/$TARGET
echo "Remove $TARGET_FOLDER to free up space'
