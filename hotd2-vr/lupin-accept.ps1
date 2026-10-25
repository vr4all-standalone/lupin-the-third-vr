# Lupin acceptance scenarios. Local game data lives outside the source checkout.
param([string[]]$Only = @('profile'), [switch]$Reuse)
$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $PSScriptRoot
$harness = Join-Path $PSScriptRoot 'vr-test.ps1'
$scenarios = [ordered]@{
    profile = @{ Game='lupinshoo'; Name='lp-profile'; Seconds=9; Expect=@('NAOMI GAME ID \[LUPIN THE THIRD  -THE SHOOTING-\]','VR: camera profile for LUPIN THE THIRD  -THE SHOOTING-') }
    guns = @{ Game='lupinshoo'; Name='lp-guns'; Seconds=12; XrSim=$true; Config='config:vr.DualP1Left=no,config:vr.GameHands=no'; At=@('2=xr left/menu 1 150','3=stick right 0 -1 150','3.5=stick right 0 -1 150','4.2=stick right 1 0 150','5=stick right 1 0 150','6=xr right/b 1 150'); Expect=@('XR: menu open \(paused\)','XR: menu Gun -> Arcade gun','XR: menu Gun -> Zapper','XR: menu closed \(resumed\)') }
    wider = @{ Game='lupinshoo'; Name='lp-wider'; Port=27036; Seconds=92; Visible=$true; Config='config:vr.FovScale=2,config:vr.WidenFov=yes'; At=@('74=rip 1 1 1','76=shot wider'); Expect=@('VR: camera profile for LUPIN THE THIRD  -THE SHOOTING-','VR: the game''s field of view widened \(code at 8c075e1e\)','VR: ripped pass') }
    hud = @{ Game='lupinshoo'; Name='lp-hud'; Port=27036; Seconds=150; Visible=$true; Config='config:vr.DualP1Left=no,config:vr.GameHands=no,config:vr.FovScale=2,config:vr.WidenFov=yes'; At=@('58=shot before','60=start','64=button 0 4 1000','68=shot instructions','70=start','84=rip 1 1 1','98=shot intro','105=rip 1 1 1','110=shot play','125=rip 1 1 1','130=shot later'); Expect=@('VR: camera profile for LUPIN THE THIRD  -THE SHOOTING-','VR: 2D layer at W 0\.534','VR: ripped pass') }
    feedback = @{ Game='lupinshoo'; Name='lp-feedback'; Port=27036; Seconds=108; XrSim=$true; Visible=$true; Config='config:vr.DualP1Left=no,config:vr.GameHands=no,config:vr.WatchRam=0ca4c808:4,0ca4c80c:4,0ca4c828:4'; At=@('60=xr right/a 1 200','64=xr right/a 1 1000','70=xr right/a 1 200','89=xr right/trigger 1 200','89.7=xr right/trigger 1 200','90.4=xr right/trigger 1 200','91.1=xr right/trigger 1 200','91.8=xr right/trigger 1 200','92.5=xr right/trigger 1 200','93.2=xr right/trigger 1 200','93.9=xr right/trigger 1 200','94.6=xr right/trigger 1 200','95.3=xr right/b 1 200','96.3=xr right/trigger 1 200','97=xr left/x 1 250','98=xr left/trigger 1 200','99=xr left/trigger 1 200','100=xr left/y 1 200','101=xr left/trigger 1 200','103=shot feedback'); Expect=@('VR: P1 magazine 0 -> 7','VR: P2 magazine 0 -> 6','XR: player 2 joins: a gun in each hand','XR: P1 kick:','XR: P2 kick:','VR: P1 calibration inverse','VR: P2 calibration inverse','VR: cutscene on','VR: cutscene off','XR: right hand: gun -> nothing \(cutscene\)','XR: right hand: nothing -> gun \(play\)') }
    empty = @{ Game='lupinshoo'; Name='lp-empty'; Port=27036; Seconds=148; XrSim=$true; Visible=$true; Config='config:vr.Widen=yes,config:vr.FovScale=2,config:vr.WidenFov=yes,config:vr.DualP1Left=no,config:vr.GameHands=yes,config:vr.BuiltInGun=no,config:vr.Gun=1,config:vr.WatchRam=0ca4c808:4,0ca4c80c:4,0ca4c828:4,0ca4c82c:4'; At=@('60=xr right/a 1 200','64=xr right/a 1 1000','70=xr right/a 1 200'); On=@('VR: P1 magazine 0 -> 7|4|xr right/trigger 1 150','VR: P1 magazine 0 -> 7|4.6|xr right/trigger 1 150','VR: P1 magazine 0 -> 7|5.2|xr right/trigger 1 150','VR: P1 magazine 0 -> 7|5.8|xr right/trigger 1 150','VR: P1 magazine 0 -> 7|6.4|xr right/trigger 1 150','VR: P1 magazine 0 -> 7|7|xr right/trigger 1 150','VR: P1 magazine 0 -> 7|7.6|xr right/trigger 1 150','VR: P1 magazine 0 -> 7|8.2|xr right/trigger 1 150','VR: P1 magazine 0 -> 7|8.8|xr right/trigger 1 150','VR: P1 magazine 0 -> 7|9.5|xr right/b 1 150','VR: P1 magazine 0 -> 7|10.5|xr right/trigger 1 150','VR: P1 magazine 0 -> 7|11.5|xr left/x 1 200','VR: P2 magazine 0 -> 6|1|xr left/trigger 1 150','VR: P2 magazine 0 -> 6|1.6|xr left/trigger 1 150','VR: P2 magazine 0 -> 6|2.2|xr left/trigger 1 150','VR: P2 magazine 0 -> 6|2.8|xr left/trigger 1 150','VR: P2 magazine 0 -> 6|3.4|xr left/trigger 1 150','VR: P2 magazine 0 -> 6|4|xr left/trigger 1 150','VR: P2 magazine 0 -> 6|4.6|xr left/trigger 1 150','VR: P2 magazine 0 -> 6|5.2|xr left/trigger 1 150','VR: P2 magazine 0 -> 6|5.8|xr left/y 1 150','VR: P2 magazine 0 -> 6|6.8|xr left/trigger 1 150','VR: P2 magazine 0 -> 6|7.5|shot floor-level','VR: P2 magazine 0 -> 6|8|xr left/menu 1 150','VR: P2 magazine 0 -> 6|8.5|shot paused-level','VR: P2 magazine 0 -> 6|9|pose head 0 1.6 0 25 -35','VR: P2 magazine 0 -> 6|9.5|shot floor-right','VR: P2 magazine 0 -> 6|10|pose head 0.15 1.6 -0.1 -25 -45','VR: P2 magazine 0 -> 6|10.5|shot floor-left','VR: P2 magazine 0 -> 6|11|pose head 0 1.6 0 0 0','VR: P2 magazine 0 -> 6|11.5|shot paused-reset','VR: P2 magazine 0 -> 6|12|xr left/menu 1 150','VR: P2 magazine 0 -> 6|13|xrstate visible','VR: P2 magazine 0 -> 6|14|xrstate focused','VR: P2 magazine 0 -> 6|15|shot focused'); Expect=@('XR: P1 kick:','XR: P2 kick:','XR: player 1 reload button \(sensor\)','XR: player 2 reload button \(sensor\)','XR: player 2 joins','XR: player 2 is out: one gun again','VR: hid original-depth shot marker') }
    camera = @{ Game='lupinshoo'; Name='lp-camera'; Seconds=92; Visible=$true; At=@('74=rip 1 1 1','76=shot camera'); Expect=@('VR: camera profile for LUPIN THE THIRD  -THE SHOOTING-','VR: focal 879\.4 x 879\.4','VR: ripped pass') }
}
$failed = $false
foreach ($name in $Only) {
    if (-not $scenarios.Contains($name)) { throw "Unknown Lupin scenario: $name" }
    $args = $scenarios[$name]
    $log = Join-Path $repo ("build-win\vrtest\{0}\flycast.log" -f $args.Name)
    if ($Reuse) {
        foreach ($pattern in $args.Expect) {
            if (-not (Test-Path -LiteralPath $log) -or -not (Select-String -LiteralPath $log -Pattern $pattern -Quiet)) { Write-Output "FAIL $name missing $pattern"; $failed = $true }
        }
    } else {
        & $harness @args
        if ($LASTEXITCODE -ne 0) { Write-Output "FAIL $name harness exit $LASTEXITCODE"; $failed=$true }
    }
    if ($name -eq 'empty' -and (Test-Path -LiteralPath $log)) {
        foreach ($player in 1,2) {
            $want = if ($player -eq 1) { 8 } else { 7 }
            $count = @(Select-String -LiteralPath $log -Pattern "XR: P$player kick:").Count
            if ($count -ne $want) { Write-Output "FAIL empty P$player $count kicks, expected $want accepted rounds"; $failed=$true }
            else { Write-Output "PASS P$player $count kicks for full magazine + one after reload; empty pulls have none" }
            $hand = if ($player -eq 1) { 'right' } else { 'left' }
            $clicks = @(Select-String -LiteralPath $log -Pattern "XRSIM: haptic $hand 0\.019 0\.350").Count
            if ($clicks -ne 2) { Write-Output "FAIL P$player $clicks empty clicks, expected two actual empty pulls"; $failed=$true }
            else { Write-Output "PASS P$player exactly two empty clicks" }
        }
    }
    if (-not $failed) { Write-Output "PASS $name" }
}
exit $(if ($failed) { 1 } else { 0 })
