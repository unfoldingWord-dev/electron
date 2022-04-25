## Building Electronite on MacOS
### Setup on MacOS Monterey
- Configured using these notes as a reference: https:https://github.com/unfoldingWord/electronite/blob/v17.3.1-graphite/docs/development/build-instructions-macos.md
- Building for x64 does not work on M1 Silicon Macs, only for Arm64.  On Intel based Macs can build for both Arm64 and Intel x64
- Make sure you have a lot of free disk space - need over 150GB free.
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
```
- installed electron build-tools (https://github.com/electron/build-tools):
``` 
sudo npm i -g @electron/build-tools
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
e build electron
```

- Make the release to ~/Develop/Electronite-Build/src/out/arm64/dist.zip
```
e build electron:dist
```

#### Build Intel x64
- open terminal and initialize build (I had to turn off goma or initialzation would fail):
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
git checkout tags/v18.1.0-graphite -b v18.1.0-graphite
cd ../..
```

- now get the Electronite sources
```
e sync
```

- Do build (takes a long time)
```
e use x64
e build electron
```

- Make the release to ~/Develop/Electronite-Build/src/out/x64/dist.zip
```
e build electron:dist
```

