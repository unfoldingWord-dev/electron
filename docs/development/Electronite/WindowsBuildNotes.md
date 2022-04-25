## Building Electronite on Windows
### Setup on Clean Windows 10 VM
- Configured my VM using these notes as a reference:
  - https://chromium.googlesource.com/chromium/src/+/main/docs/windows_build_instructions.md#visual-studio
  - https://github.com/unfoldingWord/electronite/blob/v17.3.1-graphite/docs/development/build-instructions-windows.md
- Make sure the VM has a lot of disk space - I configured with 220GB of storage.
- Make sure to add exception to the build folder for Windows defender, or it will delete a couple of the build files.
- Add to git support for long file names: `git config --system core.longpaths true`
- Installed VS 2019 Community edition and Windows SDK 10.0.19041.0.
- Installed Python 3.9.11 (Python 3.10 has breaking changes that broke compile) from https://www.python.org/downloads/windows/
- configured Python:
```
python3 -m pip install --upgrade pip setuptools wheel
python3 -m pip install pywin32
```
- installed node LTS
- Added environment variables:
```
2019_install=C:\Program Files (x86)\Microsoft Visual Studio\2019\Community
WINDOWSSDKDIR=C:\Program Files (x86)\Windows Kits\10
```

- installed: https://chocolatey.org/install
	
- Setup Build tools (using command prompt, not powershell):
```
C:
cd %HOMEPATH%
git clone https://github.com/electron/build-tools .electron_build_tools
cd .electron_build_tools
npm i
```

### Build Electronite
#### Build Intel x64
- open command prompt and initialize build:
```
e init --root=.\Build-Electron -o x64 x64 -i release --goma cache-only --fork unfoldingWord-box3/electron --use-https -f
```

- edit `~\.electron_build_tools\configs\evm.x64.json`
and add option to args:       `"target_cpu = \"x64\""`

- get the base Electron source code (this can take many hours the first time as the git cache is loaded):
```
e sync
```

- checkout the correct Electronite tag
```
cd .\Build-Electron\src\electron
git fetch --all
git checkout tags/v18.1.0-graphite -b v18.1.0-graphite
cd ..\..
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

- Make the release to .\Build-Electron\src\out\x64\dist.zip
```
e build electron:dist
```

#### Build Intel x86
- open command prompt and initialize build:
```
e init --root=.\Build-Electron -o x86 x86 -i release --goma cache-only --fork unfoldingWord-box3/electron --use-https -f
```

- edit `~\.electron_build_tools\configs\evm.x86.json`
  and add option to args:       `"target_cpu = \"x86\""`

- get the base Electron source code (this can take many hours the first time as the git cache is loaded):
```
e sync
```

- checkout the correct Electronite tag
```
cd .\Build-Electron\src\electron
git fetch --all
git checkout tags/v18.1.0-graphite -b v18.1.0-graphite
cd ..\..
```

- now get the Electronite sources
```
e sync
```

- Do build (takes a long time)
```
e use x86
e build electron
```

- Make the release to .\Build-Electron\src\out\x86\dist.zip
```
e build electron:dist
```

