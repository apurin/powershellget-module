Write-Host "Install!"

Function Test-MyInstall {
    Write-Host "Test-MyInstall yey!"
}

$packageRoot = Split-Path -Path $PSScriptRoot -Parent

Import-Module ( Join-Path -Path $packageRoot -ChildPath Microsoft.Skype.Tools.Tools.Tools.psd1 )