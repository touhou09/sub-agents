<#
.SYNOPSIS
    Claude Code & Cursor Setup Script for Windows

.DESCRIPTION
    Installs global templates for Claude Code and Cursor IDE.

.PARAMETER Claude
    Install Claude Code global templates only

.PARAMETER Cursor
    Install Cursor global rules only

.PARAMETER All
    Install both Claude Code and Cursor

.PARAMETER Symlink
    Use symlinks instead of copying files (requires admin)

.PARAMETER NoBackup
    Don't backup existing files

.EXAMPLE
    .\setup.ps1 -All
    .\setup.ps1 -Claude -Symlink
    .\setup.ps1
#>

param(
    [switch]$Claude,
    [switch]$Cursor,
    [switch]$All,
    [switch]$Symlink,
    [switch]$NoBackup,
    [switch]$Help
)

# Script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoDir = Split-Path -Parent $ScriptDir

# Target directories
$ClaudeGlobalDir = Join-Path $env:USERPROFILE ".claude"
$CursorGlobalDir = Join-Path $env:USERPROFILE ".cursor"

# Source directories
$GlobalTemplates = Join-Path $RepoDir "global-templates"
$ProjectTemplates = Join-Path $RepoDir "project-templates"

# Colors
function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Type = "Info"
    )

    switch ($Type) {
        "Info"    { Write-Host "[INFO] " -ForegroundColor Blue -NoNewline; Write-Host $Message }
        "Success" { Write-Host "[OK] " -ForegroundColor Green -NoNewline; Write-Host $Message }
        "Warning" { Write-Host "[WARN] " -ForegroundColor Yellow -NoNewline; Write-Host $Message }
        "Error"   { Write-Host "[ERROR] " -ForegroundColor Red -NoNewline; Write-Host $Message }
    }
}

function Show-Banner {
    Write-Host ""
    Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Blue
    Write-Host "║     Claude Code & Cursor Setup Script                     ║" -ForegroundColor Blue
    Write-Host "║     Sub-agents & Skills Templates                         ║" -ForegroundColor Blue
    Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Blue
    Write-Host ""
}

function Show-Usage {
    Write-Host "Usage: .\setup.ps1 [OPTIONS]"
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  -Claude      Install Claude Code global templates only"
    Write-Host "  -Cursor      Install Cursor global rules only"
    Write-Host "  -All         Install both Claude Code and Cursor"
    Write-Host "  -Symlink     Use symlinks instead of copying files (requires admin)"
    Write-Host "  -NoBackup    Don't backup existing files"
    Write-Host "  -Help        Show this help message"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  .\setup.ps1 -All              # Install both with copy"
    Write-Host "  .\setup.ps1 -Claude -Symlink  # Claude only with symlinks"
    Write-Host "  .\setup.ps1                   # Interactive mode"
}

function Backup-Existing {
    param(
        [string]$Target,
        [string]$Name
    )

    if ((Test-Path $Target) -and (-not $NoBackup)) {
        $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
        $backupPath = "${Target}.backup.${timestamp}"
        Write-ColorOutput "Backing up existing $Name to $backupPath" "Warning"
        Move-Item -Path $Target -Destination $backupPath -Force
    }
}

function Install-ClaudeGlobal {
    Write-ColorOutput "Installing Claude Code global templates..." "Info"

    # Create ~/.claude directory
    if (-not (Test-Path $ClaudeGlobalDir)) {
        New-Item -ItemType Directory -Path $ClaudeGlobalDir -Force | Out-Null
    }

    # Backup existing files
    $filesToBackup = @(
        @{ Path = (Join-Path $ClaudeGlobalDir "CLAUDE.md"); Name = "CLAUDE.md" },
        @{ Path = (Join-Path $ClaudeGlobalDir "settings.json"); Name = "settings.json" },
        @{ Path = (Join-Path $ClaudeGlobalDir "agents"); Name = "agents" },
        @{ Path = (Join-Path $ClaudeGlobalDir "skills"); Name = "skills" }
    )

    foreach ($file in $filesToBackup) {
        if (Test-Path $file.Path) {
            Backup-Existing -Target $file.Path -Name $file.Name
        }
    }

    $sourceClaude = Join-Path $GlobalTemplates "CLAUDE.md"
    $sourceSettings = Join-Path $GlobalTemplates "settings.json"
    $sourceAgents = Join-Path $GlobalTemplates "agents"
    $sourceSkills = Join-Path $GlobalTemplates "skills"

    if ($Symlink) {
        # Symlink mode (requires admin)
        try {
            New-Item -ItemType SymbolicLink -Path (Join-Path $ClaudeGlobalDir "CLAUDE.md") -Target $sourceClaude -Force | Out-Null
            New-Item -ItemType SymbolicLink -Path (Join-Path $ClaudeGlobalDir "settings.json") -Target $sourceSettings -Force | Out-Null
            New-Item -ItemType SymbolicLink -Path (Join-Path $ClaudeGlobalDir "agents") -Target $sourceAgents -Force | Out-Null
            New-Item -ItemType SymbolicLink -Path (Join-Path $ClaudeGlobalDir "skills") -Target $sourceSkills -Force | Out-Null
            Write-ColorOutput "Created symlinks for Claude Code global config" "Success"
        }
        catch {
            Write-ColorOutput "Failed to create symlinks. Try running as Administrator." "Error"
            return
        }
    }
    else {
        # Copy mode
        Copy-Item -Path $sourceClaude -Destination $ClaudeGlobalDir -Force
        Copy-Item -Path $sourceSettings -Destination $ClaudeGlobalDir -Force
        Copy-Item -Path $sourceAgents -Destination $ClaudeGlobalDir -Recurse -Force
        Copy-Item -Path $sourceSkills -Destination $ClaudeGlobalDir -Recurse -Force
        Write-ColorOutput "Copied Claude Code global config" "Success"
    }

    Write-Host ""
    Write-ColorOutput "Claude Code global setup complete!" "Success"
    Write-Host "  - CLAUDE.md:     $ClaudeGlobalDir\CLAUDE.md"
    Write-Host "  - settings.json: $ClaudeGlobalDir\settings.json"
    Write-Host "  - agents\:       $ClaudeGlobalDir\agents\ (6 agents)"
    Write-Host "  - skills\:       $ClaudeGlobalDir\skills\ (37 skills, 9 categories)"
}

function Install-CursorGlobal {
    Write-ColorOutput "Installing Cursor global rules..." "Info"

    # Create ~/.cursor/rules directory
    $cursorRulesDir = Join-Path $CursorGlobalDir "rules"
    if (-not (Test-Path $cursorRulesDir)) {
        New-Item -ItemType Directory -Path $cursorRulesDir -Force | Out-Null
    }

    $cursorRulesFile = Join-Path $cursorRulesDir "global.mdc"

    if (Test-Path $cursorRulesFile) {
        Backup-Existing -Target $cursorRulesFile -Name "global.mdc"
    }

    # Create Cursor-compatible rules
    $cursorRulesContent = @"
---
description: Global rules for all projects
globs:
alwaysApply: true
---

# Global Cursor Rules

## Default Behavior

- Respond to user in Korean, use English internally
- Prioritize code quality and stability
- Prefer concise and clear explanations
- Avoid unnecessary comments or documentation

## Code Style

- Indentation: 2 spaces (JavaScript/TypeScript), 4 spaces (Python, Rust)
- Type safety: TypeScript strict mode, Python type hints
- Functions follow single responsibility principle
- Use clear and meaningful variable names

## Role Profiles

### Data Engineer Mode
- Idempotency first
- Consider data lineage tracking
- Include data quality validation

### Fullstack Developer Mode
- Prefer rapid prototyping
- User experience focused design
- Consider accessibility (a11y)

### DevOps Mode
- Infrastructure as Code principles
- Security first (least privilege)
- Always include monitoring/alerting

## Preferred Tools/Frameworks

| Category | Tools |
|----------|-------|
| Frontend | React, Next.js, TypeScript |
| Backend | Python, FastAPI |
| Database | PostgreSQL, Redis, ClickHouse |
| DevOps | Docker, Kubernetes, Terraform |
| Data | Polars, Delta Lake, Apache Arrow |
| Testing | Playwright, pytest, Vitest |
"@

    Set-Content -Path $cursorRulesFile -Value $cursorRulesContent -Encoding UTF8
    Write-ColorOutput "Cursor global rules created" "Success"

    # Also create legacy .cursorrules
    $legacyRules = Join-Path $env:USERPROFILE ".cursorrules"
    if (Test-Path $legacyRules) {
        Backup-Existing -Target $legacyRules -Name ".cursorrules"
    }
    Copy-Item -Path $cursorRulesFile -Destination $legacyRules -Force

    Write-Host ""
    Write-ColorOutput "Cursor global setup complete!" "Success"
    Write-Host "  - Rules: $cursorRulesDir\global.mdc"
    Write-Host ""
    Write-ColorOutput "Note: Cursor global User Rules are UI-based." "Warning"
    Write-Host "  Go to: Settings > Cursor Settings > Rules > User Rules"
    Write-Host "  Paste the content from: $cursorRulesFile"
}

function Start-InteractiveMode {
    Write-Host ""
    Write-Host "Select installation target:"
    Write-Host "  1) Claude Code only"
    Write-Host "  2) Cursor only"
    Write-Host "  3) Both Claude Code and Cursor"
    Write-Host "  4) Exit"
    Write-Host ""

    $choice = Read-Host "Enter choice [1-4]"

    switch ($choice) {
        "1" { $script:InstallClaude = $true }
        "2" { $script:InstallCursor = $true }
        "3" { $script:InstallClaude = $true; $script:InstallCursor = $true }
        "4" { Write-Host "Exiting."; exit 0 }
        default { Write-ColorOutput "Invalid choice" "Error"; exit 1 }
    }

    Write-Host ""
    $symlinkChoice = Read-Host "Use symlinks instead of copy? (requires admin) [y/N]"
    if ($symlinkChoice -match "^[Yy]") {
        $script:Symlink = $true
    }
}

# Main
if ($Help) {
    Show-Usage
    exit 0
}

Show-Banner

# Check if source exists
if (-not (Test-Path $GlobalTemplates)) {
    Write-ColorOutput "Global templates not found at: $GlobalTemplates" "Error"
    exit 1
}

Write-ColorOutput "Detected OS: Windows" "Info"

# Set flags
$InstallClaude = $Claude -or $All
$InstallCursor = $Cursor -or $All

# Interactive mode if no flags
if (-not $InstallClaude -and -not $InstallCursor) {
    Start-InteractiveMode
}

Write-Host ""
$mode = if ($Symlink) { "Symlink" } else { "Copy" }
$backupStatus = if ($NoBackup) { "Disabled" } else { "Enabled" }
Write-ColorOutput "Installation mode: $mode" "Info"
Write-ColorOutput "Backup: $backupStatus" "Info"
Write-Host ""

# Install selected targets
if ($InstallClaude) {
    Install-ClaudeGlobal
    Write-Host ""
}

if ($InstallCursor) {
    Install-CursorGlobal
    Write-Host ""
}

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "  Setup complete!" -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Restart Claude Code / Cursor to apply changes"
Write-Host "  2. For project-level setup, copy project-templates\ to your project"
Write-Host ""
