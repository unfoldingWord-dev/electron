#!/bin/bash
set -e

# Copy all electronite builds for all architectures from results to S3 storage.
#  it will copy all OS's and architectures found
#  First do cd to build folder before running script. 
#  Only parameter is version.  If AWS keys are not set, will do prompting.
#
# troubleshooting:
#   Got an S3 error that AWS user did not exist when entering credentials at prompts.  
#     No obvious reason for this, but found it started working by either setting or 
#     clearing ID `export AWS_SECRET_ACCESS_KEY=` before running script.
#
# Example `./copy_all_to_s3.py v25.3.2`

VERSION=$1

echo "Copying Electronite builds for VERSION to S3"

# turn off history
set +o history

# set AWS Keys in environment variables
if [ "$AWS_ACCESS_KEY_ID" == "" ]; then
  read -p "Enter AWS_ACCESS_KEY_ID: " KEY_ID
  export AWS_ACCESS_KEY_ID=$KEY_ID
fi
if [ "$AWS_SECRET_ACCESS_KEY" == "" ]; then
  read -p "Enter AWS_SECRET_ACCESS_KEY: " ACCESS_KEY
  export AWS_SECRET_ACCESS_KEY=$ACCESS_KEY
fi

#!/bin/bash

# Set the directory to the parent folder
results_dir="results"

# Loop through each subfolder in the parent folder
for TARGET_DIR in "$results_dir"/*; do
    VERSION_DIR="$TARGET_DIR/$VERSION"
    # Check if the current item is a directory
    if [ -d "$VERSION_DIR" ]; then
        TARGET=$(basename "$TARGET_DIR")
        echo "found TARGET_DIR: $VERSION_DIR"
        for ARCH_DIR in "$VERSION_DIR"/*; do
            ARCH=$(basename "$ARCH_DIR")
            DIST_PATH="$ARCH_DIR/dist.zip"
            if [ -f "$DIST_PATH" ]; then
              echo "found ARCH_DIR dist: $DIST_PATH"
              echo "found TARGET: $TARGET"
              echo "found ARCH: $ARCH"
              set -x
              /usr/local/bin/aws s3 cp results/${TARGET}/${VERSION}/${ARCH}/dist.zip s3://electronite-build-data/Electronite/${TARGET}/${VERSION}/${ARCH}/dist.zip
              set +x
            fi
        done
    fi
done

#if [ "`uname`" == "Darwin" ]; then
#  echo "Detected Mac"
#  TARGET_DIR=mac
#else
#  echo "Fallback to Linux"
#  TARGET_DIR=linux
#fi

set -x

## do the s3 copy commands and then exit bash
## presumes to current folder is the build folder
#/usr/local/bin/aws s3 cp results/${TARGET_DIR}/${VERSION}/arm64/dist.zip s3://electronite-build-data/Electronite/${TARGET_DIR}/${VERSION}/arm64/dist.zip
#/usr/local/bin/aws s3 cp results/${TARGET_DIR}/${VERSION}/x64/dist.zip s3://electronite-build-data/Electronite/${TARGET_DIR}/${VERSION}/x64/dist.zip

set +x

if [ "$KEY_ID" != "" ]; then
  echo "Clearing temp AWS_ACCESS_KEY_ID"
  export AWS_ACCESS_KEY_ID=
fi

if [ "$ACCESS_KEY" != "" ]; then
  echo "Clearing temp AWS_SECRET_ACCESS_KEY"
  export AWS_SECRET_ACCESS_KEY=
fi

echo "All copies completed for $VERSION"
