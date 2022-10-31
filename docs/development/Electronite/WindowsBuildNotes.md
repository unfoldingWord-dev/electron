## Building Electronite on Windows
### Setup on Clean Windows 10 VM
- Configured my VM using these notes as a reference:
  - https://chromium.googlesource.com/chromium/src/+/main/docs/windows_build_instructions.md#visual-studio
  - [build-instructions-windows](../build-instructions-windows.md)
- Make sure the VM has a lot of disk space - I configured with 220GB of storage.
- if you have trouble building with these notes, you could try the older Chromium Build tools: [WindowsBuildNotesChromeTools](WindowsBuildNotesChromeTools.md) 
- Make sure to add exception to the build folder for Windows defender, or it will delete a couple of the build files.
  - Go to Start button > Settings > Update & Security > Windows Security > Virus & threat protection.
  - Under Virus & threat protection settings, select Manage settings, and then under Exclusions, select Add or remove exclusions.
  - Add folder `.\Build-Electron` (which is the default build folder used below, or the build folder you actually use).
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
	
- Setup Build tools (using command prompt, not powershell).  Install using powershell didn't work for me:
```
npm i -g @electron/build-tools
C:
cd %HOMEPATH%
git clone https://github.com/electron/build-tools .electron_build_tools
cd .electron_build_tools
npm i
```

#### Monitoring Goma status
- if you browse to http://localhost:8088 on your local machine you can monitor compile jobs as they flow through the goma system.

### Build Electronite
#### Build Intel x64
- open command prompt and initialize build configuration (note that if you have a slow or unreliable internet connection, it is better to change the goma setting from `cache-only` to `none`):
```
rem - first cd to the base build directory and run:
e init --root=.\Build-Electron -o x64 x64 -i release --goma cache-only --fork unfoldingWord/electronite --use-https -f
```

- edit `~\.electron_build_tools\configs\evm.x64.json`
and add option to args:       `"target_cpu = \"x64\""`

- get the Electron source code (this can take many hours the first time as the git cache is loaded), checkout the correct Electronite tag and get build sources
```
e sync
cd .\Build-Electron\src\electron
git fetch --all
git checkout tags/electronite-v20.3.3-beta -b electronite-v20.3.3-beta
cd ..\..
e sync
```

- Do build (takes a long time)
```
.\electronite-tools-2.bat build x64
```

- Test the build.
    - Do `e start`.
    - Open the developer console by typing`Control-Shift-I`.
    - in console execute `window.location="https://scripts.sil.org/cms/scripts/page.php?site_id=projects&item_id=graphite_fontdemo"`
    - Ensure all the tests pass by visually inspecting the rendered fonts and comparing against the image samples on the site.
    - The example for Padauk from server will not be correct with the triangles.  So need to:
      Open elements tab, select body of html, do Control-F to search, and search for `padauk_ttf`, and apply attribute `font-feature-settings: "wtri" 1;`.  The triangles should now be rendered correctly.

- Make the release to .\Build-Electron\src\out\Release-x64\dist.zip
```
.\electronite-tools-2.bat release x64
```

#### Build Intel x86 (32 bit)
- if Electronite source already checked out, then skip to `Do build` step.

- get the Electron source code (this can take many hours the first time as the git cache is loaded), checkout the correct Electronite tag and get build sources
```
e sync
cd .\Build-Electron\src\electron
git fetch --all
git checkout tags/electronite-v20.3.3-beta -b electronite-v20.3.3-beta
cd ..\..
e sync
```

- Do build (takes a long time)
```
.\electronite-tools-2.bat build x86
```

- Make the release to .\Build-Electron\src\out\Release-x86\dist.zip
```
.\electronite-tools-2.bat release x86
```

#### Build Intel arm64
- if Electronite source already checked out, then skip to `Do build` step.

- get the Electron source code (this can take many hours the first time as the git cache is loaded), checkout the correct Electronite tag and get build sources
```
e sync
cd .\Build-Electron\src\electron
git fetch --all
git checkout tags/electronite-v20.3.3-beta -b electronite-v20.3.3-beta
cd ..\..
e sync
```

- Do build (takes a long time)
```
.\electronite-tools-2.bat build arm64
```

- Make the release to .\Build-Electron\src\out\Release-arm64\dist.zip
```
.\electronite-tools-2.bat release arm64
```

