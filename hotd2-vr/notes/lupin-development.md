# Lupin the Third VR

A standalone Quest and PC VR port in development for **Lupin the Third: The Shooting**
(Sega NAOMI). It derives from Confidential Mission VR 1.2 and mikermak's
[hotd2-vr](https://github.com/mikermak/hotd2-vr), itself a fork of
[Flycast](https://github.com/flyinghead/flycast). It carries over the CM VR menus and features,
using Lupin's own camera, game state and gun model.

**Development build.** The port includes the final CM 1.2 menus, controller controls and labels,
gun choices, first-run extraction, reload modes, haptics, dual wielding and independent setup.
Lupin uses its own guarded camera, original hit-test lens, two-player calibration and native
accepted-round state. [Validation evidence](../../hotd2-vr/notes/lupin-validation.md) separates
simulator/build checks from the still-untested physical headset checks. Quest comfort,
tracking, sustained performance and later-stage coverage need hands-on validation.

The [approved design](../../docs/superpowers/specs/2026-10-24-lupin-vr-design.md) defines the target.
[The implementation plan](../../docs/superpowers/plans/2026-10-24-lupin-vr.md) tracks the work, and
[Lupin findings](../../hotd2-vr/notes/lupin-findings.md) records measured evidence and unresolved
questions. Tests and addresses for another game are not evidence of Lupin support.

Unofficial fan project, not affiliated with Sega, Namco, Meta or the Flycast project.
**No game is included.** Use your own game files. Never commit or attach ROMs, discs, PICs,
RAM dumps, screenshots, saves or generated game models.

## Supported game files

Initial scope is the **original GDS-0018** revision, Flycast/MAME set `lupinshoo`.
**Rev A (`lupinsho`, GDS-0018A) is not supported.** The supplied original disc was found
under misleading Rev A names. Keep the originals untouched and prepare a separate correctly
named copy; renaming a Rev A disc does not turn it into the original.

| File | Required layout |
|---|---|
| `lupinshoo.zip` | Original set, with `317-0325-jpn.pic` inside; keep it packed |
| `lupinshoo/gds-0018.chd` | Original disc, in the `lupinshoo` folder beside the ZIP |
| `naomi.zip` | Supported NAOMI BIOS beside the game ZIP, or a compatible BIOS entry inside the game ZIP |

Original CHD header SHA1: `3b7d5dd917b9a2cc9b7b51aad22f8e75383c3301`.
The Android setup checks the CHD header revision and ZIP entry metadata; it does not scan
and verify every game byte. A complete original-named `gds-0018.cue` or `gds-0018.gdi` with
all referenced nonempty tracks is also recognized. **Raw CUE/GDI boot is untested.**
Use lowercase canonical set and disc paths, especially on case-sensitive storage.

## Quest development setup

Quest 3 is the primary target. Quest 3S, Quest 2, Quest Pro and PC VR compatibility are
inherited targets, with physical headset validation pending for this Lupin port.

The standalone package is `lupin-the-third-vr-quest.apk`, application ID
`com.vrlightgunhub.lupin`, label **Lupin the Third VR**, base version `1.0.1`, versionCode
`2`. The APK versionName also records the source commit: `1.0.1-g<commit>`.
This app has its own settings and saves and can coexist with Confidential Mission VR.
These are local builds; no publication or headset installation is part of this work.

For an independently built development APK, put your files in the headset's shared Download
folder using USB file transfer or your sideloading tool:

```text
Download/
    lupinshoo.zip
    lupinshoo/
        gds-0018.chd
    naomi.zip
```

Open **Lupin the Third VR** from Unknown sources. The VR4ALL-style setup panel provides
**Allow** for All files access, **Look again**, individual file badges, and a **Play** button
that stays disabled until its structural file checks pass. READY means the game files satisfy those structural checks. The app's private
`files/games` and external `files/games` folders are checked too, without shared-storage
access. File/adb launches go through the same game-selection checks.

The setup runs in its own `:setup` process. Relaunching Play ends only this app's old game
process; Quit returns to the setup panel. The setup lifecycle has JVM checks; physical Quest relaunch/quit remains on the headset checklist.

Settings use `/sdcard/Android/data/com.vrlightgunhub.lupin/files/emu.cfg`.
Do not reuse another game's settings, generated gun cache or model data as evidence
for this port. First start watches Lupin's attract demo to extract one complete train-guard handgun
(24 strips, 86 triangles, 0.22 m barrel). Preparation reached 72 game seconds in about
15 wall seconds on this development PC. Quest timing is unmeasured. B skips to the Arcade
gun; the next launch retries. Valid caches are reused and corrupt/incomplete caches regenerate.

## PC VR development setup

The portable archive is `lupin-the-third-vr-pcvr.zip`. Its top level contains
`flycast.exe`, `emu.cfg`, `README.txt`, `LICENSE.txt`, and **Play Lupin the Third.cmd**.
Licensed bundled models, when explicitly supplied for a build, add `CREDITS.txt` and
`data/models/`. The archive contains no game files.

Prepare a separate folder containing the build, then add your own files:

```text
flycast.exe
emu.cfg
Play Lupin the Third.cmd
roms/
    lupinshoo.zip
    lupinshoo/gds-0018.chd
    naomi.zip
```

Connect the headset to the active OpenXR runtime, then run **Play Lupin the Third.cmd**.
The launcher selects `roms\lupinshoo.zip` and sets the archive folder as the working directory
so the portable `emu.cfg` belongs to this copy. The generated defaults are:

```ini
[config]
pvr.rend = 0
rend.NativeDepthInterpolation = yes
vr.Xr = yes
```

This selects OpenGL, native depth interpolation and VR. Portable configuration and native standalone selection are checked; actual OpenXR headset use remains untested. There is no measured Lupin world-scale recommendation
or headset performance result yet.

## Controls and parity target

Bindings match the final CM 1.2 controls; feedback and joining use Lupin's native game state.
The default below assigns P1 to the right hand. **Hands** swaps P1/P2 Start buttons, dual-player
reload buttons, gun hands and controller labels. Single-player shooting still follows either trigger:

| Quest Touch input | Action |
|---|---|
| Right A / B | P1 Start / P1 Reload |
| Left X / Y | P2 Start or join / P2 Reload |
| Triggers | Shoot for the assigned player; either hand can fire P1 before P2 joins |
| Left menu | Open or close paused VR settings |
| Left stick click | Recenter |
| Right stick click | Toggle laser |
| Grip + stick up/down | World size |
| Grip + stick left/right | Gun size |
| Stick | Game D-pad |

The paused menu preserves this exact order: Resume, Recenter, Gun, Gun angle,
Reload, Hands, Laser, Haptics, World size, Panel distance, Wider view, How to play, Quit. It preserves either-hand pointer selection, stick repeat, a live gun preview, three-second Quit
confirmation, and simulation/audio pause with live head tracking.

**Hands** offers P1 right/P2 left or P1 left/P2 right and saves immediately. With two players
active, changing it swaps their guns after closing the menu; a held trigger must be released.
How to play updates the labels for Touch, Index, Vive and WMR. Trigger labels sit above Stick
labels where the controller has a stick. During noninteractive story scenes both hands are empty;
the guns return for play, and How to play can still show the controls while paused.

**Haptics** offers Off, Light, Medium (default) and Strong. Light keeps the original normal
pulse, Medium lasts 1.6 times as long and Strong 2.4 times; Off keeps visual recoil and flash.
Old numeric 0/1/2/3 and low/normal settings remain readable. New choices save as words.

The two drawing and hit-test lenses remain separate when Wider view is enabled: the
train is drawn at about 80 degrees while shots keep its original 40-degree hit test.
The adapter inverts the cabinet's live calibration without writing EEPROM or breaking
its off-screen reload sensor. P1 uses seven rounds and P2 six; accepted rounds drive recoil,
flashes and haptics. No CM assault rifle or its pickup rules are added to Lupin.

## User models

The inherited engine supports guns as `guns/<name>.glb` with a matching JSON sidecar, and
controllers as `controllers/left.glb` / `right.glb` with matching sidecars. The same selection, override and fallback rules apply in Lupin. Only add files you
have rights to use.

On Quest, user folders are beside the game ZIP, for example `Download/guns/` and
`Download/controllers/`. On PC, folders beside `flycast.exe` take priority, followed by
folders beside the game ZIP, followed by licensed bundled models in `data/models/`.
A same-named user model overrides its bundled counterpart. Do not use a generated model
from another game as Lupin's in-game pistol.

A gun sidecar supplies its name, grip, muzzle, up direction and length in metres:

```json
{ "name": "My gun", "grip": [0, 0, 0], "muzzle": [0, 0.03, -0.18],
  "up": [0, 1, 0], "length": 0.22 }
```

The bundled Zapper is 0.30 m long. The example above describes an arbitrary
user gun, not a measured Lupin weapon. The inherited conversion helper is
`hotd2-vr/tools/make-gun.py`; model credits and licensing remain required for distribution.

## Build and focused checks

Windows builds use the inherited C++17 Flycast/OpenXR project. `hotd2-vr/build-win.cmd Release`
builds the standalone Lupin Windows app (`RelWithDebInfo OFF` permits inherited-game regression tests); `hotd2-vr/build-quest.cmd` invokes the optimized arm64 `vr` Gradle variant.
The Android SDK needs NDK `29.0.14206865` and CMake `3.22.1`. Set `ANDROID_HOME` and
`JAVA_HOME` for your machine; the inherited scripts also look for a Microsoft JDK 17.
The Gradle daemon toolchain file currently requests JDK 21, so that toolchain must be
available as well. Keep writable build/config/save paths independent from other ports.

The Quest APK build path is
`shell/android-studio/flycast/build/outputs/apk/vr/flycast-vr.apk` before release packaging.
Without the existing external release-signing configuration, Gradle uses the public debug
key and warns. That is a test build, not a release.

Focused checks:

```powershell
# Synthetic package checks: no builds, emulator, game data or signing keys.
powershell -NoProfile -ExecutionPolicy Bypass -File hotd2-vr/package-release-tests.ps1

# Plain Java setup/status tests through the Android project, when its toolchain is configured.
cd shell/android-studio
.\gradlew.bat :flycast:testDebugUnitTest
```

Additional isolated checks (set `VRLGH_GAMES` to a private original-set copy first):

```powershell
.\hotd2-vr\re\gun_input_test.cmd
.\hotd2-vr\re\standalone_game_test.cmd
.\hotd2-vr\lupin-accept.ps1 -Only feedback,empty
.\hotd2-vr\lupin-aim.ps1
.\hotd2-vr\lupin-aim.ps1 -Stock
.\hotd2-vr\lupin-ui-accept.ps1
.\hotd2-vr\lupin-settings-test.ps1
.\hotd2-vr\lupin-cm-sync.ps1
```

The Java suites are `LupinFilesTest` and `LupinStartStatusTest`. They cover original layout,
missing/mismatched files, PIC/BIOS metadata, embedded BIOS, nested/case variants, bounded
scans, CUE/GDI tracks, setup status and explicit launch validation. Direct Java/JUnit runs
also work without invoking native builds.

Use the Lupin isolation harness and findings for game research. Runs must own only their
launched PID, private writable paths and UDP port `27026`. Do not run a script that kills all
Flycast processes or swaps another port's/shared ROM-folder models. The original reference
checkout and the player's original ROM layout must remain untouched.

## Release packaging and remaining gates

`hotd2-vr/package-release.ps1` targets:

- `dist/lupin-the-third-vr-quest.apk`
- `dist/lupin-the-third-vr-pcvr.zip`

It preserves the release policy: clean committed source, APK version commit resolving to
HEAD, matching native commit attestations, release signing, APK package/label/versionCode/
sole setup launcher checks, controller-model permission, exact portable archive contents,
matching bundled model lists, GPL-3.0/cgltf notices and a credit entry for every model.
Game discs/sets/keys, generated game models, rips, frame grabs and signing files are rejected.
`-CheckOnly <archives>` performs content/licence/credit checks; it is not APK identity or
signer verification. `-SkipBuild` uses existing builds but does not waive provenance checks.
`-AllowDebugKey` marks test packaging and relaxes release signer/provenance requirements;
it does not certify a release.

Release signing stays outside this repository under the existing `VRLGH_SIGNING` configuration
or the user's `.vrlightgunhub` folder. Preserve that private material; do not print, copy,
commit or package it. No key creation, publication or headset installation is part of the
current port work. A distributed GPL build needs its corresponding source commit.

Build and simulator results are recorded in the validation report. Physical headset checks
remain unchecked in [the headset checklist](../../hotd2-vr/notes/lupin-vr-headset-checklist.md).
Complete those checks and later stages before advertising headset compatibility or performance.

## Problems and research reports

Use the [bug form](../../.github/ISSUE_TEMPLATE/bug_report.yml) with the build commit, headset/runtime,
original revision, file format and reproduction steps. PC logs are `flycast.log` when enabled;
Quest logs can be collected with `adb logcat -d -s flycast:*`. Keep game data, dumps,
screenshots containing game artwork, generated game models and signing secrets out of issues
and commits. Existing source-game findings are retained for attribution and engine reference;
they do not establish Lupin behavior.

## Credits and licences

- **[hotd2-vr](https://github.com/mikermak/hotd2-vr) (The House of the Dead 2 VR) by
  mikermak**: Lupin the Third VR derives from Confidential Mission VR and this fork. The VR mode, the panel the
  start screen grew from and the tools are his. GPL-2.0-or-later.
- [Flycast](https://github.com/flyinghead/flycast) by flyinghead and contributors, GPL-2.0
  or later. This fork's code is too (see `LICENSE`); changed Flycast files carry a note,
  and `git log master..` shows every change. Flycast's own readme:
  [README.flycast.md](../../README.flycast.md).
- The gun: ["Namco Arcade Gun"](https://sketchfab.com/3d-models/namco-arcade-gun-15fbd5b9add94a34b5c21746e3dd32be)
  by [Martoscar](https://sketchfab.com/Martoscar), made for Age of Joy, licensed
  [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/). Changed: re-oriented and
  moved into the controller's aim space, quantised, textures and materials dropped,
  recoloured, converted to a C++ header (`core/rend/vr/gun_model.h`, CC BY 4.0). Since CC
  BY 4.0 goes together with GPL-3.0 but not GPL-2.0, the builds, which include it (the Quest
  app and the PC version), are distributed under **GPL-3.0**, which Flycast's "or later"
  allows. The source is published with every release.
- The bundled models, in the release builds only (not in this repository; `CREDITS.txt` in
  the APK and the zip lists them with what was changed):
  ["Namco Arcade Gun"](https://sketchfab.com/3d-models/namco-arcade-gun-15fbd5b9add94a34b5c21746e3dd32be)
  by Martoscar, [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/);
  ["Nintendo Zapper"](https://sketchfab.com/3d-models/nintendo-zapper-e2a445cbf957439ab3a3f0c0408cd422)
  by BIGDOGLOBAL (bdglobal), [CC BY-ND 4.0](https://creativecommons.org/licenses/by-nd/4.0/);
  ["Meta Quest Left Controller"](https://sketchfab.com/3d-models/meta-quest-left-controller-c70d4a544ddf4b5d8155c2edaff6f9de)
  and ["Meta Quest Right Controller"](https://sketchfab.com/3d-models/meta-quest-right-controller-5221accf9c7842eb9b2d4df2d2e5c545)
  by declan02530, CC BY 4.0. They are files of their own next to the app, not part of its
  code, each under its own licence.
- [OpenXR loader](https://github.com/KhronosGroup/OpenXR-SDK) by Khronos, Apache-2.0.
- [cgltf](https://github.com/jkuhlmann/cgltf) by Johannes Kuhlmann, MIT (reads the GLB models:
  the bundled ones and your own). Its notice is in `LICENSE.txt`, in the APK (`assets/LICENSE.txt`)
  and in the zip.
- Roboto (Flycast's own copy, on the headset's panel) by Google, Apache-2.0.
- [MediaPipe](https://github.com/google-ai-edge/mediapipe) by Google, Apache-2.0
  (finger-gun tracker); [Capstone](https://www.capstone-engine.org/), BSD.
- PC VR rendering in an OpenGL Core Profile: [nn10n10](https://github.com/nn10n10) (pull request
  #1 to hotd2-vr).
- The app's icon is drawn for it from plain shapes (`hotd2-vr/assets/make-icon.py`).
- Inspired by [DR-89/time-crisis-vr](https://github.com/DR-89/time-crisis-vr).
- The game and character names belong to their respective owners. Namco is a trademark of Bandai Namco, Zapper of Nintendo, Meta Quest of Meta.

Unofficial fan project, not affiliated with Sega. No game is included.

## Two-player hand layout (1.0.1)

The menu toggle **2P: P1 left / P2 right** saves `vr.DualP1Left` and defaults to On, including upgrades from the earlier global `vr.P1Hand` setting. It affects only active dual wield. Solo controls stay A for P1 Start, X to join P2, either trigger to move the gun, and either reload button. Once P2 joins, X/Y belong to P1 on the left and A/B to P2 on the right; Off reverses the dual layout. A held join Start remains P2 until release.
