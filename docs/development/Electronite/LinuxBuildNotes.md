## Building Electronite on Linux
### Setup on Clean Linux VM
- Configured my VM using these notes as a reference: https://github.com/unfoldingWord/electronite/blob/v17.3.1-graphite/docs/development/build-instructions-linux.md
- Make sure the VM has a lot of disk space - I ran out of disk space with 60GB of storage configured.  Rather than starting over with a new VM.  I added a second Virtual Hard Drive with 100GB and then used that drive for the builds.

### Build Electronite
- to create `arm64` builds, you must have installed the arm64 dependencies mentioned in the Linux build instructions above.  Then run:
```
cd electron-gn/src
build/linux/sysroot_scripts/install-sysroot.py --arch=arm64
cd ../..
```
- to create `arm` builds, you must have installed the arm dependencies mentioned in the Linux build instructions above.  Then run:
```
cd electron-gn/src
build/linux/sysroot_scripts/install-sysroot.py --arch=arm
cd ../..
```
- install and configure python:
```
sudo apt install python python3.9
pip3 install --user --upgrade pip
pip3 install --user pyobjc
```

- installed electron build-tools (https://github.com/electron/build-tools):
```
npm i -g @electron/build-tools
```
- it still didn’t work, so tried this and then initialization seemed to work:
```
git clone https://github.com/electron/build-tools ~/.electron_build_tools && (cd ~/.electron_build_tools && npm install)
``` 

### Build Electronite
#### Build Arm64
- open terminal and initialize build:
```
e init --root=~/Develop/Electronite-Build -o arm64 arm64 -i release --goma cache-only --fork unfoldingWord/electronite --use-https -f
```

- edit `~/.electron_build_tools/configs/evm.arm64.json`
  and add option to args:       `"target_cpu = \"arm64\""`
- get the base Electron source code (this can take many hours the first time as the git cache is loaded):
```
e sync
```

- checkout the correct Electronite tag
```
cd ~/Develop/Electronite-Build/src/electron
git fetch --all
git checkout tags/v18.1.0-graphite -b v18.1.0-graphite
cd ../..
```

- now get the Electronite sources
```
e sync
```

- Do build (takes a long time)
```
e use arm64
export NINJA_STATUS="[%r processes, %f/%t @ %o/s : %es] "
e build electron
```

- Make the release to ~/Develop/Electronite-Build/src/out/arm64/dist.zip
```
e build electron:dist
```

   