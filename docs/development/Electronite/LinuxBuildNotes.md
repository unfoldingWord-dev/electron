## Building Electronite on Linux
### Setup on Clean Linux VM
- Configured my VM using these notes as a reference: https://github.com/unfoldingWord/electronite/blob/v18.2.1-graphite/docs/development/build-instructions-linux.md
- Make sure the VM has a lot of disk space - I ran out of disk space with 60GB of storage configured.  Rather than starting over with a new VM.  I added a second Virtual Hard Drive with 100GB and then used that drive for the builds.
- if you have trouble building with these notes, you could try the older Chromium Build tools: https://github.com/unfoldingWord/electronite/blob/v18.2.1-graphite/docs/development/Electronite/LinuxBuildNotesChromeTools.md
- upgrade to g++ 8.4:
```
sudo apt install build-essential
sudo apt -y install g++-7 g++-8
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-8 8
g++ --version
```
- to create `arm64` and `arm` builds, you must have installed the arm dependencies mentioned in the Linux build instructions above.  Then run:
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
- if e commands don’t work, try this and then initialization seemed to work:
```
git clone https://github.com/electron/build-tools ~/.electron_build_tools && (cd ~/.electron_build_tools && npm install)
``` 

#### Monitoring Goma status
- if you browse to http://localhost:8088 on your local machine you can monitor compile jobs as they flow through the goma system.


### Build Electronite
#### Build x64
- open terminal and initialize build configuration (note that if you have a slow or unreliable internet connection, it is better to change the goma setting from `cache-only` to `none`):
```
e init --root=~/Develop/Electronite-Build -o x64 x64 -i release --goma cache-only --fork unfoldingWord/electronite --use-https -f
```

- edit `~/.electron_build_tools/configs/evm.x64.json`
  and add option to args:       `"target_cpu = \"x64\""`
- get the base Electron source code (this can take many hours the first time as the git cache is loaded):
```
e sync
```

- checkout the correct Electronite tag
```
cd ~/Develop/Electronite-Build/src/electron
git fetch --all
git checkout tags/v18.2.1-graphite -b v18.2.1-graphite
cd ../..
```

- now get the Electronite sources
```
e sync
```

- Do build (takes a long time)
```
e use x64
export NINJA_STATUS="[%r processes, %f/%t @ %o/s : %es] "
e build electron
```

- Make the release to ~/Develop/Electronite-Build/src/out/x64/dist.zip
```
./src/electron/script/strip-binaries.py -d src/out/x64
e build electron:dist
```

#### Build x86
- open terminal and initialize build configuration (note that if you have a slow or unreliable internet connection, it is better to change the goma setting from `cache-only` to `none`):
```
sudo apt-get install ia32-libs-gtk ia32-libs
e init --root=~/Develop/Electronite-Build -o x86 x86 -i release --goma cache-only --fork unfoldingWord/electronite --use-https -f
```

- edit `~/.electron_build_tools/configs/evm.x86.json`
  and add option to args:       `"target_cpu = \"x86\""`
- get the base Electron source code (this can take many hours the first time as the git cache is loaded):
```
e sync
```

- to create `x86` builds, you must have installed the x86 dependencies mentioned in the Linux build instructions above.  Then run:
```
cd ./src
build/linux/sysroot_scripts/install-sysroot.py --arch=x86
cd ..
```

- checkout the correct Electronite tag
```
cd ~/Develop/Electronite-Build/src/electron
git fetch --all
git checkout tags/v18.2.1-graphite -b v18.2.1-graphite
cd ../..
```

- now get the Electronite sources
```
e sync
```

- Do build (takes a long time)
```
e use x86
export NINJA_STATUS="[%r processes, %f/%t @ %o/s : %es] "
e build electron
```

- Make the release to ~/Develop/Electronite-Build/src/out/x86/dist.zip
```
./src/electron/script/strip-binaries.py --target-cpu=x86 -d src/out/x86
e build electron:dist
```

#### Build Arm64
- open terminal and initialize build configuration (note that if you have a slow or unreliable internet connection, it is better to change the goma setting from `cache-only` to `none`):
```
e init --root=~/Develop/Electronite-Build -o arm64 arm64 -i release --goma cache-only --fork unfoldingWord/electronite --use-https -f
```

- edit `~/.electron_build_tools/configs/evm.arm64.json`
  and add option to args:       `"target_cpu = \"arm64\""`
- get the base Electron source code (this can take many hours the first time as the git cache is loaded):
```
e sync
```

- to create `arm64` builds, you must have installed the arm64 dependencies mentioned in the Linux build instructions above.  Then run:
```
cd ./src
build/linux/sysroot_scripts/install-sysroot.py --arch=arm64
cd ..
```

- checkout the correct Electronite tag
```
cd ~/Develop/Electronite-Build/src/electron
git fetch --all
git checkout tags/v18.2.1-graphite -b v18.2.1-graphite
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
./src/electron/script/strip-binaries.py --target-cpu=arm64 -d src/out/arm64
e build electron:dist
```

#### Build arm
- open terminal and initialize build configuration (note that if you have a slow or unreliable internet connection, it is better to change the goma setting from `cache-only` to `none`):
```
e init --root=~/Develop/Electronite-Build -o arm arm -i release --goma cache-only --fork unfoldingWord/electronite --use-https -f
```

- edit `~/.electron_build_tools/configs/evm.arm.json`
  and add option to args:       `"target_cpu = \"arm\""`
- get the base Electron source code (this can take many hours the first time as the git cache is loaded):
```
e sync
```

- to create `arm` builds, you must have installed the arm dependencies mentioned in the Linux build instructions above.  Then run:
```
cd ./src
build/linux/sysroot_scripts/install-sysroot.py --arch=arm
cd ..
```

- checkout the correct Electronite tag
```
cd ~/Develop/Electronite-Build/src/electron
git fetch --all
git checkout tags/v18.2.1-graphite -b v18.2.1-graphite
cd ../..
```

- now get the Electronite sources
```
e sync
```

- Do build (takes a long time)
```
e use arm
export NINJA_STATUS="[%r processes, %f/%t @ %o/s : %es] "
e build electron
```

- Make the release to ~/Develop/Electronite-Build/src/out/arm/dist.zip
```
./src/electron/script/strip-binaries.py --target-cpu=arm -d src/out/arm
e build electron:dist
```
