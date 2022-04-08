# Electronite Build Notes

Preliminary

# Original Wiki Notes for electronite-v12.0.5:
Electronite is a version of Electron that is patched to support rendering [graphite](https://github.com/silnrsi/graphite) enabled fonts.

# Updating

When updating the code, the standard is to create new branches like `electronite-v12.0.5`. These eventually get pushed up to the server and tagged for the release.

## Graphite

For minor grahite updates you can simply change the version of graphite needed in `/DEPS`.

For example, this updates graphite from [1.3.13](https://github.com/silnrsi/graphite/releases/tag/1.3.13) to [1.3.14](https://github.com/silnrsi/graphite/releases/tag/1.3.14).
```diff
-'graphite_version': 'b45f9b271214b95f3b42e5c9863eae4b0bfb7fd7',
+'graphite_version': '92f59dcc52f73ce747f1cdc831579ed2546884aa',
```

If there are larger changes to the graphite API you may need to do some patching in the Electron code see [[Graphite Patch]].

## Electron

The simplest way to update electron is to pull down the branch from upstream and re-apply the [[Graphite Patch]]. This avoids merge conflicts and an ugly commit history.

Updating electron is pretty straight forward.
1. Get the version of electron that you want to update to, e.g. `git checkout upstream v12.0.5`.
2. Branch from electron `git checkout -b electronite-12.0.5`
3. Apply the [[Graphite Patch]] `git am add-graphite-to-electron.patch` (you might need to manually apply it if there are conflicting changes from upstream).
4. Build and test the electronite branch (see below).
5. If everything is working properly, push the branch and tag the release using the proper naming convention, and create a new release based on your new tag with the compiled binaries attached to it.
6. Upload a patched version of `electron.d.ts` to the release as well for easy reference. See https://github.com/unfoldingWord-dev/electronite-cli/blob/master/README.md#development for details.

# Building

Before using these scripts you must install the [prerequisites](https://github.com/electron/electron/blob/master/docs/development/build-instructions-gn.md). Just read the "Platform prerequisites" and "GN prerequisites" sections.

Also, you'll want to build code from a properly tagged release because [other tooling](https://github.com/topics/electronite) expects a specific naming convention.
When tagging a new release of electronite use the same naming convention as electron with the addition of a `-graphite` suffix. For example if electron has a `v7.2.3` release, electronite will have a corresponding `v7.2.3-graphite` release.

> Note: When building electronite you will need to download about 16 gb of source code.

Below are some scripts to help you compile electronite. Copy the correct script for your platform and make it executable.

* [electronite-tools.sh for Linux / macOS](https://gist.github.com/da1nerd/95a95297310dd7e4c0b87a9093f999d8)
* [electronite-tools.bat for Windows](https://gist.github.com/da1nerd/9e5b4fdd0f80d764e737d066e8cb224d)

Running the scripts without arguments will display the following commands which you will generally want to execute in order:

1. `get <ref>` fetches all of the code. Where `<ref>` is a branch or tag.
2. `build` compiles electronite
3. `release` creates the distributable.

After running the above commands you will have a zipped file at `./electron-gn/src/out/Release/dist.zip`. You can rename this file and  upload it as an artifact to the proper release on Github. Here's the naming convention:

* `electronite-<version>-win32-x64.zip`
* `electronite-<version>-win32-ia32.zip`
* `electronite-<version>-linux-x64.zip`
* `electronite-<version>-darwin-x64.zip`

> You must compile Electronite on a Linux, Windows, and macOS in order to generate the three distributables above.
>  Cross compilation is not possible.

Where `<version>` is the tagged release without the `-graphite` suffix. e.g. `electronite-v7.2.3-linux-x64.zip`

## Troubleshooting

#### Delete cached repository
If you encounter errors while fetching the source code (this includes chromium) you may need to delete one of the cached repositories, or a lock file. Look through the console output to identify the repository that was being fetched when the download failed. Delete the identified repository from your `.git_cache` and also delete any `.lock` files. Re-run the download and it should succeed.

#### Disable your VPN
This problem has only been seen on some Linux systems.
It is necessary to disable any active VPNs on the computer in order to successfully download the source code. If you do not, you may get errors about not being able to reach one of the source code servers. If this occurs, delete the affected cached repository if any and try again after turning off your VPN.

#### Select Xcode build tools

If you get an error like the following:
```
xcode-select: error: tool 'xcodebuild' requires Xcode, but active developer directory '/Library/Developer/CommandLineTools' is a command line tools instance
```

You need to select the Xcode application
```
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
```

## Help!

Check out this [Electronite playlist](https://www.youtube.com/playlist?list=PLf7IRQ2kP73kmC8y8gLQoHs4I26LzrRrq) on YouTube if you need some help using the scripts.

# Testing

Once you have a compiled electronite binary you can test it by visiting this page https://scripts.sil.org/cms/scripts/page.php?site_id=projects&item_id=graphite_fontdemo.

* Run electronite
* Open the developer console in the running electronite instance.
* execute `window.location="the test url above"`
* Ensure all the tests pass by visually inspecting the rendered fonts and comparing against the image samples on the site.

## Troubleshooting

Some font elements need to be enabled via css flags, and these flags are specific to each browser.
On the test page mentioned above, the padauk font uses a Mozilla specific css flag, but since electronite is based on chromium those don't work. Therefore, it is necessary to tweak the css a little.


```diff
.padauk_ttf {
  font-family: PadaukT, sans-serif;     
  font-size: 150%;
-  -moz-font-feature-settings: "wtri=1";
-  -moz-font-feature-settings: "wtri" 1;
+  font-feature-settings: "wtri" 1;
}
```

See [this issue](https://github.com/unfoldingWord/translationCore/issues/6879#issuecomment-624429380) for a detailed explaination.