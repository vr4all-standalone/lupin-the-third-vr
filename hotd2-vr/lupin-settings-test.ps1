# Exercise real settings, haptic and held-state functions without an XR runtime.
param([string]$Output='')
$ErrorActionPreference='Stop'
$repo=(Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
if(-not $Output){$Output=Join-Path $repo 'build-win\vrtest\lp-sync-settings'}
$out=[IO.Path]::GetFullPath($Output)
if(-not $out.StartsWith([IO.Path]::GetFullPath((Join-Path $repo 'build-win'))+'\',[StringComparison]::OrdinalIgnoreCase)){throw 'Test output must stay under build-win'}
New-Item -ItemType Directory -Path $out -Force | Out-Null
$hostSource=[IO.File]::ReadAllText((Join-Path $repo 'core\rend\vr\xr_host.cpp'))
$functions=@()
foreach($signature in @('int dualP1Hand()','int p1Hand()','void playerStartButtons(bool leftStart, bool rightStart, bool& p1Start, bool& p2Start)','int hapticsLevel()','float haptic(int hand, float seconds, float amplitude)','Holds holds(int hand)')){
 $begin=$hostSource.IndexOf($signature+"`n{")
 if($begin -lt 0){$begin=$hostSource.IndexOf($signature+"`r`n{")}
 if($begin -lt 0){throw "Missing production function $signature"}
 $finish=$hostSource.IndexOf("`n}",$begin)
 if($finish -lt 0){throw 'Missing production function end'}
 $functions+=$hostSource.Substring($begin,$finish+2-$begin)
}
$swapBegin=$hostSource.IndexOf('if (dualWield && guns[0].hand != hand1)')
$swapEnd=$hostSource.IndexOf("`n`t}",$swapBegin)
if($swapBegin -lt 0 -or $swapEnd -le $swapBegin){throw 'Missing production hand-swap block'}
$functions += "void syncHands(int hand1) {`n"+$hostSource.Substring($swapBegin,$swapEnd+3-$swapBegin)+"`n}"
[IO.File]::WriteAllText((Join-Path $out 'settings_under_test.inc'),($functions -join "`n"),[Text.UTF8Encoding]::new($false))
$soloBegin=$hostSource.IndexOf('Gun& gun = guns[0];',$hostSource.IndexOf('void updateLightgun('))
$soloEnd=$hostSource.IndexOf("`n`t// The buttons that aren't the trigger.",$soloBegin)
if($soloBegin -lt 0 -or $soloEnd -le $soloBegin){throw 'Missing production single-gun transfer block'}
$functions += "void transferSolo(const bool tracked[2], const float pulls[2]) {`n"+$hostSource.Substring($soloBegin,$soloEnd-$soloBegin)+"`n}"
[IO.File]::WriteAllText((Join-Path $out 'settings_under_test.inc'),($functions -join "`n"),[Text.UTF8Encoding]::new($false))
$vswhere=Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio\Installer\vswhere.exe'
$vsroot=& $vswhere -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath
$envCmd=Join-Path $vsroot 'VC\Auxiliary\Build\vcvars64.bat'
$cpp=Join-Path $PSScriptRoot 're\lupin_settings_test.cpp'
$exe=Join-Path $out 'lupin_settings_test.exe'
$log=Join-Path $out 'build.log'
Push-Location $out
try {
 & $env:ComSpec /d /c "call `"$envCmd`" >nul && cl /nologo /std:c++17 /EHsc /O2 /W3 /I`"$out`" /Fe`"$exe`" `"$cpp`" >`"$log`" 2>&1"
 if($LASTEXITCODE -ne 0){Get-Content -LiteralPath $log;throw 'Settings test compilation failed'}
 & $exe
 $code=$LASTEXITCODE
}finally{Pop-Location}
exit $code