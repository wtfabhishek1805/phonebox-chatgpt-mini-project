# Add-on for PhoneBox 0.9.22: replace the FIRST Sessions widget with a
# ChatGPT companion Custom HTML widget. Preserves all other pages and settings.
# No changes are made until the user types YES. A timestamped backup is created.
[CmdletBinding()]
param([switch]$WhatIf)
$ErrorActionPreference = 'Stop'
$cfgPath = Join-Path $env:APPDATA 'PhoneBox\config.json'
$widgetPath = Join-Path $PSScriptRoot 'phonebox-chatgpt-widget.html'

if (-not (Test-Path -LiteralPath $cfgPath)) {
    throw "PhoneBox config was not found: $cfgPath. Start PhoneBox and save settings once."
}
if (-not (Test-Path -LiteralPath $widgetPath)) {
    throw "Missing widget file: $widgetPath"
}

$raw = [System.IO.File]::ReadAllText($cfgPath, [System.Text.Encoding]::UTF8)
$config = $raw | ConvertFrom-Json
if (-not $config.pages) { throw 'No PhoneBox pages found. Nothing changed.' }

$widget = $null
$pageIndex = -1
for ($i = 0; $i -lt $config.pages.Count; $i++) {
    $page = $config.pages[$i]
    if (-not $page.widgets) { continue }
    foreach ($w in $page.widgets) {
        if ($w.type -eq 'sessions') { $widget = $w; $pageIndex = $i; break }
    }
    if ($null -ne $widget) { break }
}
if ($null -eq $widget) {
    throw 'No saved Sessions widget found. In PhoneBox Settings > Pages > Sessions, click Save once, then rerun. If still missing, follow README manual setup. Nothing changed.'
}

$existing = @($config.shortcuts | Where-Object { $_.id -eq 'chatgpt-open' })
if ($existing.Count -gt 1) { throw 'Duplicate chatgpt-open shortcut IDs detected. Nothing changed.' }
if ($existing.Count -eq 1 -and $existing[0].cmd -ne 'https://chatgpt.com/') {
    throw 'The chatgpt-open shortcut ID already exists with another target. Nothing changed.'
}

Write-Host "PhoneBox config: $cfgPath"
Write-Host "Replacing the Sessions widget on page $($pageIndex + 1)."
Write-Host 'The GitHub panel and your other pages will remain unchanged.'
if ($WhatIf) {
    Write-Host 'WhatIf: no files were modified.'
    exit 0
}
if ((Read-Host 'Type YES to back up and modify this config') -cne 'YES') {
    Write-Host 'Cancelled. No changes made.'
    exit 0
}

$backup = "$cfgPath.chatgpt-backup-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
Copy-Item -LiteralPath $cfgPath -Destination $backup -ErrorAction Stop

# PhoneBox accepts raw HTML content in the existing sandboxed widget type.
$widget.type = 'html'
$options = [pscustomobject]@{
    html = [System.IO.File]::ReadAllText($widgetPath, [System.Text.Encoding]::UTF8)
    transparent = $false
}
if ($widget.PSObject.Properties['options']) {
    $widget.options = $options
} else {
    $widget | Add-Member -MemberType NoteProperty -Name options -Value $options
}

if ($existing.Count -eq 0) {
    $shortcut = [pscustomobject]@{
        id = 'chatgpt-open'
        label = 'ChatGPT'
        icon = '✳'
        color = '#29d6ac'
        cmd = 'https://chatgpt.com/'
    }
    $config.shortcuts = @($config.shortcuts) + @($shortcut)
}

# Round-trip JSON rather than touching any unrelated setting deliberately.
# Warn that JSON whitespace may be rewritten; a full backup is always kept.
$json = ConvertTo-Json -InputObject $config -Depth 100
$utf8 = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($cfgPath, $json, $utf8)
Write-Host 'ChatGPT widget configured successfully.' -ForegroundColor Green
Write-Host "Backup: $backup"
Write-Host 'Refresh PhoneBox Settings > Pages and open the Sessions page on the phone.'
Write-Host 'If PhoneBox overwrites the change, exit the PhoneBox tray agent, run this script again, then reopen it.'