# powershellget-module 
Unofficial example of [PowerShellGet](http://blogs.msdn.com/b/mvpawardprogram/archive/2014/10/06/package-management-for-powershell-modules-with-powershellget.aspx)-friendly package. How to **create**, **publish** and **use**.

## Why PowerShellGet?
It is simple and reliable way to distribute PowerShell cmdlets already available on Windows 10. PowerShellGet takes care of versioning, publishing and installation. 

You can use official [PowerShell Gallery](https://www.powershellgallery.com/) source or add custom Nuget source.

## Manual
This is a detailed manual, but you can jump into a code straight away: check an example of a minimal module in `.\MyModule` folder and debug `Demo.ps1` script to see how:
-	Local folder is registered as Nuget source
-	Package is published to it
-	Package is installed from it
-	Cmdlets from package are imported and used
-	Full cleanup sequence, which returns everything to initial state

### Create 
First of all, do not repeat my mistake, do not try to create *.nuspec and pack Nuget package itself manualy, let `Publish-Module` cmdlet do the job. It adds some magic to Nuget package and without it nothing will work (it adds special Tags to nuspec file).

A module should be placed in a folder named as module. This folder should contain [module manifest](https://technet.microsoft.com/en-us/library/dd878297.aspx) and a module itself (for example, pure PowerShell module, aka [script module](https://technet.microsoft.com/en-us/library/dd878340.aspx)).

Here is the expected package structure for module named `MyModule`:

    [ MyModule ]
          MyModule.psd1
          MyModule.psm1

Don’t forget to set MyModule.psm1 as a `RootModule` inside module manifest.

### Publish
First you'll need to add a custom Nuget source. Let’s add some local folder as Nuget feed, so we can easily publish and install from there at any moment:

    Register-PSRepository -Name Demo_Nuget_Feed -SourceLocation D:\NugetFeed -PublishLocation D:\NugetFeed -InstallationPolicy Trusted

Now, we can publish our package there:

    Publish-Module -Path .\MyModule -Repository Demo_Nuget_Feed -NuGetApiKey 'use real NuGetApiKey for real nuget server here'

As you've probably noticed, we can pass anything as NuGetApiKey for folder Nuget source.

### Install and use
This is best part of PowerShellGet:

    Install-Module MyModule -Repository Demo_Nuget_Feed -Scope CurrentUser

From now we can use any cmdlet we’ve exported in MyModule.psm1.
**Once you’ve installed module it stays on system permanently.**.

Notice `-Scope` parameter of `Install-Module`, to install module for all users you'll need admin rights.
