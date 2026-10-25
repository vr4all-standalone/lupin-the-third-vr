# Lupin the Third VR validation

Original GDS-0018 only, set lupinshoo. Independent source E:\___flattovrdev\lupin-vr, branch codex/lupin-vr. Source provenance and numeric research are in lupin-findings.md. Physical headset checks remain unchecked in lupin-vr-headset-checklist.md. No game data is included.

## Feature-to-evidence matrix

| Design sections | Implemented behavior | Local evidence |
|---|---|---|
|1,2|Stereo reconstruction, tracked view, guarded live camera and independent original hit lens; widening|XR simulator gameplay/pause; causal front/rear head hits; original lens2756/7281; production lp-aim-wide and lp-aim-stock render headers|
|3|Both-player calibration, corners/edges/center and native reload sentinel; narrow original-marker removal|23 input/calibration checks;32 actual game VM points across widening modes (sampled max1px/axis);10 causal boundary cases;40 marker UV positives/119 HUD negatives|
|4|Inverse-depth HUD, flat screens, preserved near floor/walls, P2 prompt separation|lp-hud150s and instruction/text inspection;352pass P2 audit, lifecycle0-only suppression; actual-pistol downward/head-translation captures; extreme poses expose black outside the source game's drawn geometry|
|5,14|Thirteen-row paused menu, values, pointers, Quit confirmation, persisted settings|All10 lp-ui scenarios pass; real second-launch persistence; frozen image diffs0 and live head redraw|
|6,12|Touch/Index/Vive/WMR bindings and labels, hand switching, empty hands during noninteractive story scenes|lp-ui controls/profiles/labels; lp-feedback story on/off and empty-hands/gun handoff|
|7,8|Original-game pistol, licensed Arcade/Zapper, custom-model infrastructure, atomic isolated cache|Complete24-strip/86-triangle25840byte pistol;16 model/cache unit tests;4 cache runtime cases;7 renderer-consumption regression checks plus3 rejected/valid cache runtime cases; actual licensed Arcade/Zapper/pistol frames|
|9,10|Accepted-round recoil/flash/haptics, both magazines and reload modes, empty feedback|lp-feedback; lp-empty native watches: P1eight/P2seven kicks, exactly two empty clicks each, independent sensor reloads and no empty kicks; lp-reload-point: P1three/P2two automatic reloads at expected exits, full-magazine/menu suppression, held Point-mode exit and manual Y|
|11|Real P2 join/leave, separate magazines/feedback, single-gun return|lp-feedback and lp-empty native active flags, P2Start and one-gun return; measured prompt filter|
|13,14|Separate Android setup/app, exact original files, standalone native selection, portable launcher/licenses|67 Java11 JVM tests;27 native-policy checks;40 distribution tests; clean Windows/Quest build and strict signer/identity/provenance/content/license checks passed; final-source refresh pending|

## Engine regressions

Private copied ROMs/config/saves only. HOTD2 pass100s (camera, projection/widening), MOK pass112s (four actual shots max1px), CM menu pass72s, CM pause pass125s/23cycles/10captures. Frozen CM diffs0; yaw21.325; resumes2.783/3.988. The owned sentinel survived cleanup. No process-wide kill remains in the invoked harnesses.

## Current build and release gates

Windows development build links successfully with OpenXR. Clean optimized arm64 Quest APK builds successfully; identity com.vrlightgunhub.lupin, Lupin the Third VR, versionCode1/base1.0.0, sole Lupin setup launcher. Initial strict packaging passed with native/app commit5cd2ad1e7: APK21.60MiB, PCZIP10.20MiB, nine matching credited model files, signed VR Light Gun Hub identity. The final source refresh includes the additional lifecycle guard and recorded custom-control checks. Final build verification uses a separate clean committed checkout at E:\___flattovrdev\lupin-vr-release. It avoids changing dependency/index metadata in the development checkout. Actual native policy allow/reject, package identity/content/signer/license results and output hashes are recorded in dist/build-verification.json after successful packaging; absence of that report means those final gates are pending. Expected outputs dist/lupin-the-third-vr-quest.apk and dist/lupin-the-third-vr-pcvr.zip.

## Limits and next requested synchronization

Simulator checks do not prove physical tracking, feel, comfort, sustained frame rate, Android relaunch behavior or hardware/controller compatibility. No physical headset was installed or tested. Raw CUE/GDI boot, later stages and P2-continue visual transitions remain untested. Extreme head movement can expose black beyond geometry drawn by the original game camera. Five extra Lupin integration runs verify mixed-case custom GLB selection, actual second-launch persistence after file reordering, user-over-bundled Zapper override, per-side controller fallbacks, ±90 input clamping to ±30 with one-degree changes, and grip/stick world/gun scaling. Actual custom colored-box rendering was inspected. Physical model feel remains untested.

The user subsequently requested the final minor CM updates after both sessions finish. That work is queued separately in lupin-cm-followup.md; the initial12-row UI evidence is retained accurately until the synchronized feature set is validated.

## Additional model/control integration

Private `build-win/lupin-model-controls.run.log`: all five final cases pass (`lp-custom-select-real`, `lp-custom-persist-real`, `lp-custom-override-real`, `lp-angle-plus-real`, `lp-angle-minus-real`). Saved mixed-case selection survives insertion of an earlier-sorted GLB. User ZaPpEr overrides the bundled file. Missing sidecar uses the built-in controller; missing user side falls to the corresponding bundled side while retaining the other custom side. Gun angle clamps to ±30 and steps to ±29/back without ±31. WorldScale0.11->0.128 and HandScale0.68->0.77 via grip/stick. Private directories/settings restored and licensed model hashes unchanged.

Native standalone Release execution allows the loaded Lupin boot ID and rejects Confidential Mission through the ordinary load-error path before Event::Start/VR profile initialization. Fresh logs are required for both cases; only each launched hidden PID is stopped. Final run evidence is included in the build verification report.

## Final CM feature synchronization (2026-10-25)

The user authorized continuing while Claude only publishes the finished CM work. The comparison
covers reference e6bd81a97 through CM331063b79. The four applicable runtime changes are the
Hands row/P1 controller assignment, empty story hands, haptics Off/Light/Medium/Strong including
legacy-value migration and longer pulses, and Trigger-above-Stick labels. Lupin camera, original
hit-test lens/calibration, native shot state, movie detection, pistol/cache guards and app identity
remain the original port's measured implementation. The menu now has13 rows, top row+0.369m.

CM's GitHub/VR4ALL publishing, CM card/banner screenshots, version numbers and project-folder
rename are specific to that project. They add no Lupin runtime capability and are not copied as
Lupin publication or artwork claims. Lupin's independent setup remains intact.

The updated13-row menu first failed against the initial12-row player, then passed after the
adaptation. The focused production-function suite passes83 settings, pulse and held-state checks.
Final runtime evidence, committed source and refreshed package hashes are recorded in
`dist/cm-sync-verification.json`; its absence means the synchronization delivery gates remain
pending. All physical headset checklist items remain untested.


Independent review found an extra downward reload possible when swapping hands with a controller
already held down. A real production-block regression failed before the fix, then all83 focused
checks passed after the downward latch was transferred with its physical controller. All four
latch combinations are covered. The reviewer rechecked and closed the finding. A final-binary
runtime scenario also holds both controllers down through the swap, requiring no extra reload.

## 1.0.1 two-player hand layout

The hand preference is now a two-player-only On/Off toggle, **2P: P1 left / P2 right**, enabled by default through the new `vr.DualP1Left` key. Earlier `vr.P1Hand` values cannot remap solo controls. In solo, either trigger transfers the gun, A starts P1, X joins P2 and either B/Y reloads P1. With two players active, guns, Start/reload and controller labels follow the dual assignment. Turning the toggle Off reverses it.

Physical Start presses retain their logical player until release across joins, P2 leaving and menu layout changes. Ownership is sampled while paused, including release/repress events, without sending menu input into the game. A join that moves P1 onto another controller waits for its held trigger to release. Existing physical-controller downward reload latches remain intact during swaps.

The regression coverage includes production-function/block checks for solo transfers and held Start transitions, plus an actual original-game simulator route covering default layout, both solo trigger directions, held P2 join, independent accepted rounds and haptic hands, reloads, a paused release/repress around a layout change, and swapping while the controllers remain pointed down. The package version is 1.0.1 with Android versionCode 2 and the existing app identity/signing setup. Final build hashes, test results and publication checks are recorded in ignored `dist/hand-layout-verification.json`; that report is generated only after successful artifact checks. No headset is installed by this workflow.