## Building Electronite on Linux
### Setup on Clean Linux VM
- Configured my VM using these notes as a reference: [build-instructions-linux](../build-instructions-linux.md)
- Make sure the VM has a lot of disk space - I ran out of disk space with 60GB of storage configured.  Rather than starting over with a new VM.  I added a second Virtual Hard Drive with 100GB and then used that drive for the builds.
- if you have trouble building with these notes, you could try the older Chromium Build tools: [LinuxBuildNotesChromeTools](LinuxBuildNotesChromeTools.md)
- if you get warning that you need to upgrade to newer g++, here's an example of how to upgrade to g++ 10:
```
sudo apt install build-essential
sudo apt -y install g++-10
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 10
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
git checkout tags/v18.3.2-graphite-beta -b v18.3.2-graphite-beta
cd ../..
```

- now get the Electronite sources
```
e sync
```

- Do build (takes a long time)
```
export NINJA_STATUS="[%r processes, %f/%t @ %o/s : %es] "
e build electron
```

- Test the build.
    - Do `e start`.
    - Open the developer console by typing`Control-Shift-I`.
    - in console execute `window.location="https://scripts.sil.org/cms/scripts/page.php?site_id=projects&item_id=graphite_fontdemo"`
    - Ensure all the tests pass by visually inspecting the rendered fonts and comparing against the image samples on the site.
    - The example for Padauk from server will not be correct with the triangles.  So need to:
      Open elements tab, select body of html, do Control-F to search, and search for `padauk_ttf`, and apply attribute `font-feature-settings: "wtri" 1;`.  The triangles should now be rendered correctly.

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

- if Electronite source already checked out, then skip to `Build Init` step:

- get the base Electron source code (this can take many hours the first time as the git cache is loaded):
```
e sync
```

- checkout the correct Electronite tag
```
cd ~/Develop/Electronite-Build/src/electron
git fetch --all
git checkout tags/v18.3.2-graphite-beta -b v18.3.2-graphite-beta
cd ../..
```

- now get the Electronite sources
```
e sync
```

- Build Init: to create `x86` builds, you must have installed the x86 dependencies mentioned in the Linux build instructions above.  Then run:
```
cd ./src
build/linux/sysroot_scripts/install-sysroot.py --arch=x86
cd ..
```

- Do build (takes a long time)
```
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
sudo apt-get install binutils-aarch64-linux-gnu
e init --root=~/Develop/Electronite-Build -o arm64 arm64 -i release --goma cache-only --fork unfoldingWord/electronite --use-https -f
```

- edit `~/.electron_build_tools/configs/evm.arm64.json`
  and add option to args:       `"target_cpu = \"arm64\""`

- if Electronite source already checked out, then skip to `Build Init` step:

- get the base Electron source code (this can take many hours the first time as the git cache is loaded):
```
e sync
```

- checkout the correct Electronite tag
```
cd ~/Develop/Electronite-Build/src/electron
git fetch --all
git checkout tags/v18.3.2-graphite-beta -b v18.3.2-graphite-beta
cd ../..
```

- now get the Electronite sources
```
e sync
```

- Build Init: to create `arm64` builds, you must have installed the arm64 dependencies mentioned in the Linux build instructions above.  Then run:
```
cd ./src
build/linux/sysroot_scripts/install-sysroot.py --arch=arm64
cd ..
```

- Do build (takes a long time)
```
export NINJA_STATUS="[%r processes, %f/%t @ %o/s : %es] "
e build electron
```

- Make the release to ~/Develop/Electronite-Build/src/out/arm64/dist.zip
```
./src/electron/script/strip-binaries.py --target-cpu=arm64 -d src/out/arm64
e build electron:dist
```
