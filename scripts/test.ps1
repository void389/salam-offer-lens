$ErrorActionPreference = 'Stop'
$compiler = if ($env:SALAM) { $env:SALAM } else { 'salam' }
New-Item -ItemType Directory -Force -Path build | Out-Null
& $compiler build tests/test_audit.salam --backend=c --output=build/test-audit.exe
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
& ./build/test-audit.exe
exit $LASTEXITCODE
