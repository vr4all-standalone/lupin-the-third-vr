# Point reload/full-magazine/menu/held-pull integration against Lupin's real state.
param([switch]$Reuse)
$ErrorActionPreference='Stop'
$repo=Split-Path -Parent $PSScriptRoot
$name='lp-reload-point'
$p1='VR: P1 magazine 0 -> 7'; $p2='VR: P2 magazine 0 -> 6'
$one=@('0.5|pose right 0.18 1.45 -0.35 180 0','1.2|pose right 0.18 1.45 -0.35 0 0',
 '2|xr right/trigger 1 150','3|pose right 0.18 1.45 -0.35 180 0','3.8|pose right 0.18 1.45 -0.35 0 0',
 '4.5|xr right/trigger 1 150','5.5|pose right 0.18 1.45 -0.35 180 0','6.2|pose right 0.18 1.45 -0.35 0 0',
 '7|xr right/trigger 1 1200','7.3|pose right 0.18 1.45 -0.35 180 0','7.8|pose right 0.18 1.45 -0.35 0 0',
 '9.2|pose right 0.18 1.45 -0.35 180 0','10|pose right 0.18 1.45 -0.35 0 0','11|xr left/x 1 200')
$two=@('0.5|pose left -0.18 1.45 -0.35 180 0','1.2|pose left -0.18 1.45 -0.35 0 0',
 '2|xr left/trigger 1 150','3|pose left -0.18 1.45 -0.35 180 0','3.8|pose left -0.18 1.45 -0.35 0 0',
 '4.5|xr left/trigger 1 150','5.2|xr left/menu 1 150','5.6|pose left -0.18 1.45 -0.35 180 0',
 '6.5|xr left/menu 1 150','7|pose left -0.18 1.45 -0.35 0 0','7.8|pose left -0.18 1.45 -0.35 180 0',
 '8.6|pose left -0.18 1.45 -0.35 0 0','9.2|xr left/trigger 1 150','10.2|xr left/y 1 150',
 '11|pose left -0.18 1.45 -0.35 180 0','12|pose left -0.18 1.45 -0.35 0 0','14|shot reloaded')
$on=@($one|ForEach-Object{$delay,$action=$_ -split '[|]',2; "$p1|$([double]$delay+3)|$action"})+@($two|ForEach-Object{"$p2|$_"})
$run=Join-Path $repo "build-win\vrtest\$name"
if(-not $Reuse) {
 & "$PSScriptRoot\vr-test.ps1" -Game lupinshoo -Name $name -Port 27036 -XrSim -Visible -Seconds 145 `
  -Config 'config:vr.Widen=yes,config:vr.FovScale=2,config:vr.WidenFov=yes,config:vr.DualP1Left=no,config:vr.GameHands=yes,config:vr.BuiltInGun=no,config:vr.Gun=1,config:vr.Reload=1' `
  -At @('60=xr right/a 1 200','64=xr right/a 1 1000','70=xr right/a 1 200') -On $on `
  -Expect @('VR: P1 magazine 0 -> 7','VR: P2 magazine 0 -> 6','XR: player 2 joins','XR: menu closed \(resumed\)')
 if($LASTEXITCODE -ne 0){exit $LASTEXITCODE}
}
$log=Get-Content -LiteralPath (Join-Path $run 'flycast.log')
$failed=$false
foreach($check in @(
 @('XR: P1 kick:',3),@('XR: P2 kick:',3),
 @('XR: player 1 pointed off screen \(reload\)',3),@('XR: player 2 pointed off screen \(reload\)',2),
 @('XR: player 2 reload button \(sensor\)',1),@('XR: menu open \(paused\)',1),@('XR: menu closed \(resumed\)',1))) {
 $count=@($log|Where-Object{$_ -cmatch $check[0]}).Count
 if($count -ne $check[1]) {Write-Output "FAIL $($check[0]): $count, expected $($check[1])";$failed=$true}
 else {Write-Output "PASS $($check[0]): $count"}
}
function Clock([string]$line) {
 if($line -notmatch '^(\d+):(\d+):(\d+)'){throw 'Missing log clock'}
 [int]$Matches[1]*60+[int]$Matches[2]+[int]$Matches[3]/1000.0
}
foreach($player in 1,2) {
 $mag=@($log|Where-Object{$_ -cmatch "VR: P$player magazine 0 ->"})
 $events=@($log|Where-Object{$_ -cmatch "XR: player $player pointed off screen \(reload\)"})
 $want=if($player -eq 1){@(6,8.5,10.3)}else{@(3,7.8)}
 if($mag.Count -ne 1 -or $events.Count -ne $want.Count){$failed=$true;continue}
 $start=Clock $mag[0]
 for($i=0;$i -lt $want.Count;$i++) {
  $at=(Clock $events[$i])-$start
  if([Math]::Abs($at-$want[$i]) -gt .5){Write-Output "FAIL P$player point reload at+$at, expected +$($want[$i]) (point-mode exit/full-magazine/menu suppression)";$failed=$true}
  else {Write-Output "PASS P$player point reload timing +$at"}
 }
}
exit $(if($failed){1}else{0})
