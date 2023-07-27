#!/usr/bin/env python3

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
# Example `./copy_all_to_s3.py v23.3.10`

import os


def getFolders(path):
    folders = [name for name in os.listdir(path) if os.path.isdir(name)]
    print("for path", path, "found folders:", folders)
    return folders


def main():
    VERSION = os.environ['1']
    KEY_ID = os.environ['2']
    ACCESS_KEY = os.environ['3']
  
    print(f"Copying Electronite builds for {VERSION} to S3")
  
    # set AWS Keys in environment variables
    if not KEY_ID:
        KEY_ID = input("Enter AWS_ACCESS_KEY_ID: ")
  
    os.environ['AWS_ACCESS_KEY_ID'] = KEY_ID
  
    if not ACCESS_KEY:
        ACCESS_KEY = input("Enter AWS_SECRET_ACCESS_KEY: ")
  
    os.environ['AWS_SECRET_ACCESS_KEY'] = ACCESS_KEY
  
    basePath = 'results'
    targets = getFolders(basePath)
    for target in targets:
        versionPath = os.path.join(basePath, target, VERSION)
   
        if os.path.exists(versionPath):
            architectures = getFolders(versionPath)

            for architecture in architectures:
                distPath = os.path.join(versionPath, architecture, 'dist.zip')
  
                if os.path.exists(distPath):
                    copyToS3(basePath, target, VERSION, architecture)
  
    if KEY_ID:
        print("Clearing temp AWS_ACCESS_KEY_ID")
        del os.environ['AWS_ACCESS_KEY_ID']
  
    if ACCESS_KEY:
        print("Clearing temp AWS_SECRET_ACCESS_KEY")
        del os.environ['AWS_SECRET_ACCESS_KEY']
  
    print(f"All copies completed to {VERSION}")


def copyToS3(basePath, target, version, architecture):
    # call the system do the s3 copy commands
    command = f'aws s3 cp {basePath}/{target}/{version}/{architecture}/dist.zip s3://electronite-build-data/Electronite/{target}/{version}/{architecture}/dist.zip'
    print('executing:', command)
    os.system(command)


if __name__ == '__main__':
    main()
