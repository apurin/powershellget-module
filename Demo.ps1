$nugetFeedPath = Join-Path $PSScriptRoot nuget-feed
$moduleFolder = Join-Path $PSScriptRoot MyModule

Try 
{
    Write-Host 'Preparing self to temporary host Nuget feed' -ForegroundColor Yellow
    Write-Host 'PowerShellGet need to initialize Nuget provider'
    Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null


    Write-Host 'Registering script folder as Nuget repo' -ForegroundColor Yellow
    New-Item -Path $nugetFeedPath -ItemType Directory | Out-Null
    Register-PSRepository -Name Demo_Nuget_Feed -SourceLocation $nugetFeedPath -PublishLocation $nugetFeedPath -InstallationPolicy Trusted | Out-Null
    Write-Host 'Use Get-PSRepository to see available repos'


    Write-Host 'Publishing package' -ForegroundColor Yellow
    Publish-Module -Path $moduleFolder -Repository Demo_Nuget_Feed -NuGetApiKey 'use real NuGetApiKey for real nuget server here'


    Write-Host 'Installing MyModule' -ForegroundColor Yellow
    Install-Module -Name MyModule -Repository Demo_Nuget_Feed
    Write-Host 'Use. Get-InstalledModule to see installed modules'


    Write-Host 'Importing MyModule and using its cmdlets' -ForegroundColor Yellow
    Import-Module -Name MyModule
    Write-Host 'Use Get-Module to see imported modules'
    Test-MyPackage
    Test-MyPackageAgain
}
Finally 
{
    Write-Host 'Clean up: removing nuget, temporary repo and installed module' -ForegroundColor Yellow
    Unregister-PSRepository Demo_Nuget_Feed -ErrorAction SilentlyContinue
    Uninstall-Module -Name MyModule -ErrorAction SilentlyContinue
    Remove-Module -Name MyModule -ErrorAction SilentlyContinue
    Remove-Item -Path $nugetFeedPath -Recurse
}