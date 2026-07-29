#Requires -Version 5.1
<#
.SYNOPSIS
    Sync the canonical skill folder into the .claude and .agents mirrors.

.DESCRIPTION
    skills/mis-report/ is the single source of truth. This script replaces the
    contents of .claude/skills/mis-report/ and .agents/skills/mis-report/ with
    a copy of it. Run after editing anything under skills/mis-report/.

.EXAMPLE
    .\scripts\sync-skill.ps1
#>

[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

$RepoRoot  = Split-Path -Parent $PSScriptRoot
$SkillName = 'mis-report'
$Source    = Join-Path $RepoRoot "skills\$SkillName"

if (-not (Test-Path $Source)) {
    throw "Canonical skill folder not found: $Source"
}

$Targets = @(
    (Join-Path $RepoRoot ".claude\skills\$SkillName"),
    (Join-Path $RepoRoot ".agents\skills\$SkillName")
)

foreach ($Target in $Targets) {
    if (Test-Path $Target) {
        Remove-Item -Recurse -Force $Target
    }

    $Parent = Split-Path -Parent $Target
    New-Item -ItemType Directory -Force -Path $Parent | Out-Null

    Copy-Item -Recurse -Force -Path $Source -Destination $Target

    $Count = (Get-ChildItem -Path $Target -Filter '*.md' -File).Count
    Write-Host "Synced $Count file(s) -> $Target"
}

Write-Host "Done. Canonical source: $Source"
