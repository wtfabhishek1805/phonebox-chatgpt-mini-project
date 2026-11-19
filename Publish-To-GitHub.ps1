# Publishes this SOURCE PROJECT (not your PhoneBox config) to a NEW GitHub repo.
# Requires Git + authenticated GitHub CLI. The repo will be PUBLIC.
[CmdletBinding()]
param([string]$RepositoryName = 'phonebox-chatgpt-mini-project')
$ErrorActionPreference = 'Stop'
Set-Location -LiteralPath $PSScriptRoot
if ($RepositoryName -notmatch '^[A-Za-z0-9._-]+$') {
    throw 'Invalid repository name. Use letters, numbers, period, hyphen and underscore.'
}
if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw 'Git not found. Install: winget install --id Git.Git -e; then restart PowerShell.' }
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) { throw 'GitHub CLI not found. Install: winget install --id GitHub.cli -e' }
& gh auth status *> $null
if ($LASTEXITCODE -ne 0) { throw 'GitHub CLI not authenticated. Run: gh auth login' }
if (-not (& git config user.name)) { throw 'Git name not configured. Run: git config --global user.name "YOUR_GITHUB_USERNAME"' }
if (-not (& git config user.email)) { throw 'Git email not configured. Run: git config --global user.email "YOUR_GITHUB_EMAIL_OR_NOREPLY"' }
if (Test-Path -LiteralPath (Join-Path $PSScriptRoot '.git')) { throw 'Git repository already initialized. Follow PUBLISH.md instead.' }
$answer = Read-Host "Create a PUBLIC GitHub repo '$RepositoryName' and upload files? Type PUBLISH to continue"
if ($answer -cne 'PUBLISH') { Write-Host 'Cancelled: nothing published.'; exit 0 }
& gh auth setup-git
if ($LASTEXITCODE -ne 0) { throw 'Unable to configure GitHub credentials for git.' }
& git init -b main
if ($LASTEXITCODE -ne 0) { throw 'git init failed.' }
& git add .
if ($LASTEXITCODE -ne 0) { throw 'git add failed.' }
& git commit -m 'Initial commit: PhoneBox ChatGPT Companion mini project'
if ($LASTEXITCODE -ne 0) { throw 'git commit failed. Correct the issue and use PUBLISH.md to continue.' }
& gh repo create $RepositoryName --public --source . --remote origin --push
if ($LASTEXITCODE -ne 0) { throw 'GitHub creation or push failed. Local git commit is saved; follow PUBLISH.md to retry without git init.' }
Write-Host 'Repository created and pushed to GitHub.' -ForegroundColor Green
& gh repo view --web