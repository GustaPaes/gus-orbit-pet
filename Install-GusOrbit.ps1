[CmdletBinding()]
param(
    [switch]$NoSetDefault
)

$ErrorActionPreference = 'Stop'

$repositoryRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$sourceFolder = Join-Path $repositoryRoot 'pets\gus-orbit'
$codexHome = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $HOME '.codex' }
$targetFolder = Join-Path $codexHome 'pets\gus-orbit'

if (-not (Test-Path -LiteralPath $sourceFolder)) {
    throw "Pet files were not found at $sourceFolder. Run this script from the cloned or extracted repository."
}

New-Item -ItemType Directory -Force -Path $targetFolder | Out-Null
Copy-Item -Path (Join-Path $sourceFolder '*') -Destination $targetFolder -Recurse -Force

if (-not $NoSetDefault) {
    $configPath = Join-Path $codexHome 'config.toml'
    $newLine = [Environment]::NewLine

    if (Test-Path -LiteralPath $configPath) {
        $configText = Get-Content -LiteralPath $configPath -Raw

        if ($configText -match '(?m)^selected-avatar-id\s*=\s*".*"\s*$') {
            $avatarPattern = [regex]::new('(?m)^selected-avatar-id\s*=\s*".*"\s*$')
            $configText = $avatarPattern.Replace($configText, 'selected-avatar-id = "gus-orbit"', 1)
        }
        elseif ($configText -match '(?m)^\[desktop\]\s*$') {
            $desktopPattern = [regex]::new('(?m)^\[desktop\]\s*$')
            $configText = $desktopPattern.Replace($configText, "[desktop]${newLine}selected-avatar-id = `"gus-orbit`"", 1)
        }
        else {
            $configText = $configText.TrimEnd() + $newLine + $newLine + "[desktop]${newLine}selected-avatar-id = `"gus-orbit`"${newLine}"
        }
    }
    else {
        New-Item -ItemType Directory -Force -Path $codexHome | Out-Null
        $configText = "[desktop]${newLine}selected-avatar-id = `"gus-orbit`"${newLine}"
    }

    [System.IO.File]::WriteAllText($configPath, $configText, [System.Text.UTF8Encoding]::new($false))
}

Write-Host "Gus Orbit was installed in $targetFolder" -ForegroundColor Green
if ($NoSetDefault) {
    Write-Host 'The current Codex avatar was left unchanged.' -ForegroundColor Yellow
}
else {
    Write-Host 'Gus Orbit is now the selected Codex avatar.' -ForegroundColor Green
}
Write-Host 'Restart Codex Desktop to load the pet.' -ForegroundColor Cyan
