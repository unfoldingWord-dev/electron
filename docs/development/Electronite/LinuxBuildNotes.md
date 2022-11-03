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
sudo apt install python python3.10
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

### Build Electronite
#### Build x64
- get the Electronite source code for branch (this can take many hours the first time as the git cache is loaded):
```
export PATH=$PATH:~/.electron_build_tools/third_party/depot_tools:~/.electron_build_tools/src
e init --root=~/Develop/Electronite-Build -o x64 x64 -i release --goma none --fork unfoldingWord/electronite --use-https -f
./electronite-tools-2.sh get electronite-v20.3.3-beta
git apply ~/Develop/Electronite-Build/src/electronite/docs/development/Electronite/add_graphite_cpp_std_iterator.patch
```

- Do build (takes a long time)
```
./electronite-tools-2.sh build x64
```

- Test the build.
    - Do `cd src/out/Release-x64 && electron`.
    - Open the developer console by typing`Control-Shift-I`.
    - in console execute `window.location="https://scripts.sil.org/cms/scripts/page.php?site_id=projects&item_id=graphite_fontdemo"`
    - Ensure all the tests pass by visually inspecting the rendered fonts and comparing against the image samples on the site.
    - The example for Padauk from server will not be correct with the triangles.  So need to:
      Open elements tab, select body of html, do Control-F to search, and search for `padauk_ttf`, and apply attribute `font-feature-settings: "wtri" 1;`.  The triangles should now be rendered correctly.

- Make the release to ~/Develop/Electronite-Build/src/out/Release-x64/dist.zip
```
./electronite-tools-2.sh release x64
```

#### Build x86
- open terminal and initialize build configuration (note that if you have a slow or unreliable internet connection, it is better to change the goma setting from `cache-only` to `none`):
```
sudo apt-get install ia32-libs-gtk ia32-libs
```

- if Electronite source already checked out, then skip to `Build Init` step.

- get the Electronite source code for branch (this can take many hours the first time as the git cache is loaded):
```
export PATH=$PATH:~/.electron_build_tools/third_party/depot_tools:~/.electron_build_tools/src
e init --root=~/Develop/Electronite-Build -o x64 x64 -i release --goma none --fork unfoldingWord/electronite --use-https -f
./electronite-tools-2.sh get electronite-v20.3.3-beta
git apply ./src/electron/src/electronite/docs/development/Electronite/add_graphite_cpp_std_iterator.patch
```

- Build Init: to create `x86` builds, you must have installed the x86 dependencies mentioned in the Linux build instructions above.  Then run:
```
cd ./src
build/linux/sysroot_scripts/install-sysroot.py --arch=x86
cd ..
```

- Do build (takes a long time)
```
./electronite-tools-2.sh build x86
```

- Make the release to ~/Develop/Electronite-Build/src/out/Release-x86/dist.zip
```
./electronite-tools-2.sh release x86
```

#### Build Arm64
- open terminal and initialize build configuration (note that if you have a slow or unreliable internet connection, it is better to change the goma setting from `cache-only` to `none`):
```
sudo apt-get install binutils-aarch64-linux-gnu
```

- if Electronite source already checked out, then skip to `Build Init` step.

- get the Electronite source code for branch (this can take many hours the first time as the git cache is loaded):
```
export PATH=$PATH:~/.electron_build_tools/third_party/depot_tools:~/.electron_build_tools/src
e init --root=~/Develop/Electronite-Build -o x64 x64 -i release --goma none --fork unfoldingWord/electronite --use-https -f
./electronite-tools-2.sh get electronite-v20.3.3-beta
git apply ./src/electron/docs/development/Electronite/add_graphite_cpp_std_iterator.patch
```

- Build Init: to create `arm64` builds, you must have installed the arm64 dependencies mentioned in the Linux build instructions above.  Then run:
```
cd ./src
build/linux/sysroot_scripts/install-sysroot.py --arch=arm64
cd ..
```

- Do build (takes a long time)
```
./electronite-tools-2.sh build arm64
```

- Make the release to ~/Develop/Electronite-Build/src/out/Release-arm64/dist.zip
```
./electronite-tools-2.sh release arm64
```
