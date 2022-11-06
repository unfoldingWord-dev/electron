## Building Electronite on MacOS
### Setup on MacOS Big Sur
- Configured using these notes as a reference: [build-instructions-macos](../build-instructions-macos.md)
- Can build on Monterey
- Building for x64 does not work on M1 Silicon Macs, only for Arm64.  On Intel based Macs can build for both Arm64 and Intel x64
- Make sure you have a lot of free disk space - need over 150GB free.
- if you have trouble building with these notes, you could try the older Chromium Build tools: [MacBuildNotesChromeTools](MacBuildNotesChromeTools.md)

- installed node using nvm
  - install nvm: `curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash`
  - restart terminal
  - install latest stable node:
```
nvm install --lts
nvm use --lts
node --version
```
- installed homebrew: `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"`
- Installed Python 3.9 (Python 3.10 has breaking changes that broke the compile) `brew install python@3.9`
- configured Python:
```
pip3 install --user --upgrade pip
pip3 install --user pyobjc
pip3 install importlib-metadata
```
- installed electron build-tools (https://github.com/electron/build-tools):
``` 
sudo npm i -g @electron/build-tools
```

- if e commands don’t work, try this and then initialization seemed to work:
```
git clone https://github.com/electron/build-tools ~/.electron_build_tools && (cd ~/.electron_build_tools && npm install)
``` 

#### Monitoring Goma status
- if you browse to http://localhost:8088 on your local machine you can monitor compile jobs as they flow through the goma system.


### Build Electronite
#### Build Intel x64
- get the Electronite source code for branch (this can take many hours the first time as the git cache is loaded):
```
export PATH=$PATH:~/.electron_build_tools/third_party/depot_tools:~/.electron_build_tools/src
e init --root=~/Develop/Electronite-Build -o x64 x64 -i release --goma none --fork unfoldingWord/electronite --use-https -f
./electronite-tools-2.sh get electronite-v21.2.0-beta
```

- Do build (takes a long time)
```
./electronite-tools-2.sh build x64
./electronite-tools-2.sh release x64
```

- Test the build. 
  - Do `e start`. (or `open /src/out/Release-x64/Electron.app`)
  - Open the developer console by typing`Command-Alt-I`.
  - in console execute `window.location="https://scripts.sil.org/cms/scripts/page.php?site_id=projects&item_id=graphite_fontdemo"`
  - Ensure all the tests pass by visually inspecting the rendered fonts and comparing against the image samples on the site.
  - The example for Padauk from server will not be correct with the triangles.  So need to:
Open elements tab, select body of html, do command-F to search, and search for `padauk_ttf`, and apply attribute `font-feature-settings: "wtri" 1;`.  The triangles should now be rendered correctly.

- The release is at ~/Develop/Electronite-Build/src/out/x64/dist.zip

#### Build Arm64
- if Electronite source already checked out, then skip to `Do build` step:

- get the Electronite source code for branch (this can take many hours the first time as the git cache is loaded):
```
export PATH=$PATH:~/.electron_build_tools/third_party/depot_tools:~/.electron_build_tools/src
e init --root=~/Develop/Electronite-Build -o x64 x64 -i release --goma none --fork unfoldingWord/electronite --use-https -f
./electronite-tools-2.sh get electronite-v21.2.0-beta
```

- Do build (takes a long time)
```
./electronite-tools-2.sh build arm64
./electronite-tools-2.sh release arm64
```

- The release is at ~/Develop/Electronite-Build/src/out/arm64/dist.zip
