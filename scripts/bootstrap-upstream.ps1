param(
    [string]$UpstreamRepo = "https://github.com/RandyKnapp/Auga.git",
    [string]$UpstreamBranch = "main",
    [string]$PatchFile = "patches/0001-bootstrap-valheim-0.221x.diff"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path ".git")) {
    throw "Run this script from the repository root."
}

$hasUpstream = git remote | Select-String -SimpleMatch "upstream"
if (-not $hasUpstream) {
    git remote add upstream $UpstreamRepo
}

git fetch upstream $UpstreamBranch

git checkout -B bootstrap-0.221x "upstream/$UpstreamBranch"

git apply --reject --whitespace=fix $PatchFile

Write-Host ""
Write-Host "Bootstrap branch created: bootstrap-0.221x"
Write-Host "Next steps:"
Write-Host "  1. Set env vars VALHEIM_ROOT and BEPINEX_ROOT"
Write-Host "  2. Build Auga/Auga.csproj"
Write-Host "  3. Start Valheim and collect BepInEx/LogOutput.log"
Write-Host "  4. Fix runtime modules one by one"
