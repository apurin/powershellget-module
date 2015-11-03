# powershellget-module 
Unofficial example of [PowerShellGet](http://blogs.msdn.com/b/mvpawardprogram/archive/2014/10/06/package-management-for-powershell-modules-with-powershellget.aspx)-friendly module. How to **create**, **publish** and **use**.

## Why PowerShellGet?
It is simple and reliable way to distribute PowerShell cmdlets. You can easily configure custom Nuget source, PowerShellGet takes care of versioning, publishing and installation. 

You can use official [PowerShell Gallery](https://www.powershellgallery.com/) as source and add custom Nuget server.

## Manual
Here is detailed manual, but you can jump into code straight away: check example of minimal module in `.\MyModule` folder and debug `Demo.ps1` script (it requires admin rights to run) to see how:
-	Local folder is registered as Nuget source
-	Package is published to it
-	Package is installed from it
-	Cmdlets from package are imported and used
-	Full cleanup sequence, which returns everything to initial state

### Create 
First of all, do not repeat my mistake, do not try to create *.nuspec and Nuget package itself manualy, let `Publish-Module` cmdlet do the job. I adds some magic to Nuget package and without it nothing will work (it adds special Tags to nuspec file).

Module should be placed in folder named same as module. This folder should contain [module manifest](https://technet.microsoft.com/en-us/library/dd878297.aspx) and a module itself (for example, pure PowerShell module, aka [script module](https://technet.microsoft.com/en-us/library/dd878340.aspx)).

Here is expected package structure for module named `MyModule`:

    [ MyModule ]
          MyModule.psd1
          MyModule.psm1

Don’t forget to set MyModule.psm1 as a `RootModule` inside module manifest.

### Publish
First you need to add custom Nuget source. Let’s add some local folder as Nuget feed, so we can easily publish and install from there at any moment:

    Register-PSRepository -Name Demo_Nuget_Feed -SourceLocation D:\NugetFeed -PublishLocation D:\NugetFeed -InstallationPolicy Trusted

Now, we can publish our package there:

    Publish-Module -Path .\MyModule -Repository Demo_Nuget_Feed -NuGetApiKey 'use real NuGetApiKey for real nuget server here'

As you've probably noticed, we can pass anything as NuGetApiKey for folder Nuget source.

### Install and use
This is best part of PowerShellGet:

    Install-Module MyModule -Repository Demo_Nuget_Feed
    Import-Module MyModule

From now we can use any cmdlet we’ve exported in MyModule.psm1.
**Once you’ve installed module it stays on system permanently.** To reuse it you only need to call `Import-Module`.