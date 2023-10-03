$InstallDevToolsScript = Join-Path $RepoRoot '\scripts\Install-DevelopmentTools.ps1'
$FontFilesPath = Join-Path $RepoRoot '\files\Fonts\*.otf'
$PowerShellProfilePath = Join-Path $RepoRoot '\files\Profile.ps1'

function Install-DevelopmentTools() {
    pwsh $InstallDevToolsScript
}

function Install-Fonts() {
    Write-Output "Installing fonts..."

    $fonts = (New-Object -ComObject Shell.Application).Namespace(0x14)

    foreach ($file in Get-ChildItem -Path $FontFilesPath -Recurse)
    {
        $fileName = $file.Name
        if (!(Test-Path -Path "C:\Windows\Fonts\$fileName" )) {
            Get-ChildItem $file | ForEach-Object { $fonts.CopyHere($_.fullname) }
        }
    }
    
    Write-Output "Complete!! Fonts have been installed."
}

function Set-PowerShellProfile() {
    Write-Output "Setting PowerShell profile..."
    if (!(Test-Path -Path $PROFILE.CurrentUserAllHosts)) {
        New-Item -ItemType File -Path $PROFILE.CurrentUserAllHosts -Force
      }
    
    Get-Content $PowerShellProfilePath | Set-Content $PROFILE.CurrentUserAllHosts
    Write-Output "Complete!! PowerShell profile has been set."
}

function Set-GitConfigurations() {
    git config --global core.autocrlf true
    git config --global core.editor nvim
    git config --global init.defaultBranch main
    git config --global push.autoSetupRemote true
}

function Set-Wallpaper() {
    winget install --exact --id Microsoft.BingWallpaper --source winget
}

Write-Output "Starting initialization of dotfiles for local development on this Windows machine..."

$RepoRoot = Split-Path -Parent $PSScriptRoot

Install-DevelopmentTools
Install-Fonts
Set-PowerShellProfile
Set-GitConfigurations
Set-Wallpaper

Write-Output "Complete!! Machine is ready for local Windows development."