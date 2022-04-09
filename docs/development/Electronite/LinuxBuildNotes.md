## Building Electronite on Linux
### Setup on Clean Linux VM
- Configured my VM using these notes as a reference: https://github.com/unfoldingWord/electronite/blob/v17.3.1-graphite/docs/development/build-instructions-linux.md
- Make sure the VM has a lot of disk space - I ran out of disk space with 60GB of storage configured.  Rather than starting over with a new VM.  I added a second Virtual Hard Drive with 100GB and then used that drive for the builds.

### Build Electronite
- open terminal and cd to the folder you will use for build
- install the depot_tools here: `git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git`
- download build script to this folder from: https://github.com/unfoldingWord/electronite/blob/v17.3.1-graphite/docs/development/Electronite/electronite-tools.sh
- set execute permission on script: `chmod +x ./electronite-tools.sh`
- before build do: `export PATH=/path/to/depot_tools:$PATH`
- get source files (this can take several hours the first time as the git cache is loaded): `./electronite-tools.sh get v17.3.1-graphite`
- to create arm64 builds, you must have installed the arm64 dependencies mentioned in the Linux build instructions above.  Then run:
```
cd electron-gn/src
build/linux/sysroot_scripts/install-sysroot.py --arch=arm64
cd ../..
```
- builds can take over 20 hours on a VM.
- build Electronite for Intel 64-bit:
    - build for 64-bit: `./electronite-tools.sh build x64`
    - create release for 32-bit: `./electronite-tools.sh release x64`
- ~~build Electronite for Arm 64-bit~~ (this doesn't seem to be working - output is huge):
    - build for arm 64-bit: `./electronite-tools.sh build arm64`
    - create release for arm 64-bit: `./electronite-tools.sh release arm64`

