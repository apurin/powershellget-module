Write-Host "Init!"

Function Test-MyInit {
    Write-Host "Test-MyInit yey!"
}

$packageRoot = Split-Path -Path $PSScriptRoot -Parent

Import-Module ( Join-Path -Path $packageRoot -ChildPath MyModule.psd1 )