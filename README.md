<div align="center">

<img src="hotd2-vr/assets/readme-banner.jpg" alt="Lupin the Third VR — experimental Quest and PC VR port" width="100%" />

# Lupin the Third VR
### Sega NAOMI Light-Gun Adventure · Standalone Meta Quest & PC VR

[![Release v1.0.1](https://img.shields.io/badge/Release-v1.0.1_Experimental-d44c65?style=for-the-badge)](../../releases)
[![Quest and PC VR](https://img.shields.io/badge/Headset-Quest_%C2%B7_PC_VR_OpenXR-blue?style=for-the-badge)](#installation)
[![Original game required](https://img.shields.io/badge/Your_Game-lupinshoo_GDS--0018-orange?style=for-the-badge)](#what-you-need)

**[⬇️ Quest APK](../../releases/latest/download/lupin-the-third-vr-quest.apk)** · **[🖥️ PC VR ZIP](../../releases/latest/download/lupin-the-third-vr-pcvr.zip)** · **[🎮 Controls](#controls)**

**[🌐 VR4ALL — Standalone VR Mod Installer](https://github.com/vr4all-standalone/vr4all-standalone-vr-mod-installer)**

</div>

---

## Overview

**Lupin the Third VR** brings **Lupin the Third: The Shooting** to a standalone Meta Quest
or a PC VR headset. The original NAOMI game runs in Flycast; its scenes are reconstructed
in stereo around you, and your tracked controllers become the light guns.

It carries over the menus and features of **[Confidential Mission VR](https://github.com/vr4all-standalone/confidential-mission-vr)**,
using Lupin's own measured camera, aiming calibration, player state and extracted handgun.
Both projects build on **[mikermak's VR fork of Flycast](https://github.com/mikermak/hotd2-vr)**,
itself based on **[Flycast](https://github.com/flyinghead/flycast)**.

> **No game included.** You need your own original **GDS-0018** game and NAOMI BIOS.
> This is an unofficial fan project, not affiliated with Sega, Meta, the Lupin rights
> holders or the Flycast project. No ROM, disc, PIC, game graphics or sound is supplied.

**Status: experimental.** Windows and Quest builds, simulator gameplay, aiming, menus
and reload checks pass. **This Lupin port has not been tested on a physical headset.**
Tracking, comfort, sustained performance and later stages still need hands-on validation.

## Key VR Features

- **Stereo 3D and tracked viewing.** Move and turn your head inside reconstructed scenes.
  Wider view draws extra scenery while preserving the original game's hit-test lens.
  HUD, subtitles and instructions sit on a panel in front of you.
- **Your controller is the light gun.** Choose the handgun extracted from your own game,
  the Arcade gun, the Zapper, or your own GLB. Gun angle adjusts from **−30° to +30°**.
- **Feedback matches real rounds.** Recoil, muzzle flash and haptics happen when the game
  fires. Empty magazines give a click without a firing kick. Haptics offers
  **Off, Light, Medium and Strong**.
- **Two players on one headset.** P2 joins with the other controller, with a separate gun,
  magazine, lives and score. **2P: P1 left / P2 right** is On by default and applies only while both players are active.
- **Two reload modes.** Shoot away from the view, or just point away once per exit.
  **B/Y** reload too. P1 has seven rounds; P2 has six.
- **Empty hands in story scenes.** Guns, controllers and lasers disappear during
  noninteractive movies and return when play resumes.
- **A paused menu in the headset.** Choose guns, angle, reload, hands, laser, haptics,
  world size, panel distance and wider view. Settings save immediately. How to play
  shows labelled controllers, and Quit needs a second selection.
- **A start screen that checks your files.** See READY or which file needs attention
  before Play enables. Separate app identity, settings and saves let it coexist with CM.

<a id="installation"></a>
## Installation on Meta Quest

Quest 3 is the primary target. Quest 3S, Quest 2, Quest Pro and PC VR are inherited
compatibility targets; physical validation is pending for this Lupin port.

<a id="what-you-need"></a>
### What you need

Use the **original GDS-0018**, MAME/Flycast set **`lupinshoo`**.
**Rev A (`lupinsho`, `gds-0018a`) is not supported.** Renaming a Rev A disc does not turn
it into the original revision.

| File | Where it goes on the Quest |
| :--- | :--- |
| `lupinshoo.zip`, with `317-0325-jpn.pic` inside | `Download/lupinshoo.zip` — keep it packed |
| Original `gds-0018.chd` | `Download/lupinshoo/gds-0018.chd` |
| `naomi.zip` | `Download/naomi.zip`, unless a supported BIOS is already inside the game ZIP |

The app checks the CHD header against the original revision. Its combined header SHA-1 is
`3b7d5dd917b9a2cc9b7b51aad22f8e75383c3301`. These are structural/header checks, not a scan
of every game byte. Keep the canonical lowercase paths.

### 1. Enable developer mode

Enable developer mode for your Quest in the Meta Horizon app and connect it to your PC by USB.
Allow USB debugging on the headset. If you already use VR4ALL or SideQuest, this may be set up.

### 2. Install with VR4ALL

**[Get VR4ALL](https://github.com/vr4all-standalone/vr4all-standalone-vr-mod-installer)**,
open the latest build, select **Lupin the Third VR** and provide your own three files above.

VR4ALL downloads the Quest APK, installs it, enables All files access and copies your
files to the correct folders. It does not supply the game or BIOS.

**Or by hand:** download the [Quest APK](../../releases/latest/download/lupin-the-third-vr-quest.apk)
and install it with SideQuest, or ADB:

```sh
adb install -r lupin-the-third-vr-quest.apk
adb shell appops set com.vrlightgunhub.lupin MANAGE_EXTERNAL_STORAGE allow
```

Copy your own files to the Download layout above. The app also recognizes complete
original-named CUE/GDI sets with all tracks; **raw CUE/GDI boot remains untested**.
The VR4ALL recipe uses CHD.

### 3. Play

Open **Lupin the Third VR** under **Unknown sources**. Use **Allow** if it needs file access,
**Look again** to rescan, then **Play** when READY. Quit from VR returns to this screen.

First launch watches the attract demo to prepare a handgun from your own game.
**B skips** preparation for that launch and uses the Arcade gun; a later launch retries.
Completed caches are reused and incomplete caches regenerate. The captured model is the
train guards' handgun, not a claim to be Lupin's personal Walther. No extracted game model
comes with the release.

Package: `com.vrlightgunhub.lupin`. Updates retain this app's settings and saves.

## PC VR

1. Download the [PC VR ZIP](../../releases/latest/download/lupin-the-third-vr-pcvr.zip) and unpack it.
2. Add your own files beside `flycast.exe`:

   ```text
   roms/
       lupinshoo.zip
       lupinshoo/gds-0018.chd
       naomi.zip
   ```

3. Connect your headset to the active OpenXR runtime, such as SteamVR or Quest Link.
4. Run **Play Lupin the Third.cmd**.

The archive includes portable settings, licensed gun/controller models, credits and the
software licence. It includes no game files. Physical PC VR headset use remains untested.

<a id="controls"></a>
## Controls

Default Quest Touch assignment:

| Input | Action |
| :--- | :--- |
| Right A / B | P1 Start / P1 Reload |
| Left X / Y | P2 Start or join / P2 Reload |
| Trigger | Shoot; either hand can hold P1's single gun before P2 joins |
| Left Menu | Open/close the paused settings menu |
| Left stick click | Recenter |
| Right stick click | Toggle laser |
| Grip + stick up/down | World size |
| Grip + stick left/right | Gun size |
| Stick | Game D-pad |

**2P: P1 left / P2 right** defaults to **On**. Solo play keeps A/B for P1 Start/Reload,
and pulling either trigger moves the single gun to that hand. X joins P2; while both
players are active, P1 uses the left gun and X/Y, and P2 uses the right gun and A/B.
Turn the option Off for P1 right / P2 left. Changing it swaps the dual guns after the menu
closes; a held trigger waits for release. A held join button stays P2 Start until released.
Touch, Index, Vive and WMR have their own labels and bindings. How to play shows them,
with Trigger above Stick where present.

## The menu

**Resume · Recenter · Gun · Gun angle · Reload · 2P: P1 left / P2 right · Laser · Haptics · World size ·
Panel distance · Wider view · How to play · Quit**

Either hand can point and select; stick navigation and repeat work too. Game and audio
pause while head tracking stays live. Menu pointers remain visible with Laser off.
Quit needs a second selection within three seconds.

## Bring your own models

Add GLBs and matching JSON sidecars in `Download/guns/` or `Download/controllers/` on Quest.
PC uses `guns/` and `controllers/` beside the player or game files. User models override
matching bundled files, and controller sides fall back independently.
[Model format and development notes](hotd2-vr/notes/lupin-development.md#user-models).

## Known limits and testing

- Physical tracking, comfort, controller feel, sustained frame rate and compatibility remain
  untested. Include your headset and build version when reporting a problem.
- Extreme head movement can reveal black beyond geometry drawn by the original game camera.
- Later stages, raw CUE/GDI boot and mixed P1-active/P2-continue timing need more testing.

[Validation evidence](hotd2-vr/notes/lupin-validation.md) ·
[Headset checklist](hotd2-vr/notes/lupin-vr-headset-checklist.md) ·
[Measured Lupin research](hotd2-vr/notes/lupin-findings.md) ·
[Build and development notes](hotd2-vr/notes/lupin-development.md)

## Credits and licence

- **Flycast** by flyinghead and contributors. **mikermak's VR fork** supplies the original
  VR rendering, tools and model infrastructure. Links are in the overview above.
- **Confidential Mission VR** provides the standalone setup, menus and reusable gun features.
  Lupin adapts them to its original revision, camera, calibration and native game state.
- Individual model authors, licences and transformations appear in the release's **CREDITS.txt**.
- This software build is distributed under **GNU GPL version 3**; see [LICENSE-RELEASE.txt](LICENSE-RELEASE.txt). Upstream source notices retain their GPL-2.0-or-later terms.
  Upstream notices and history are preserved. Original game and character rights remain
  with their owners. The project title graphic contains no game screenshot or character art.

The first release binaries were verified from **`00706171d`**. The release tag identifies
that corresponding source; the project page on `main` may have newer documentation.
Game data and release signing material are never included.
