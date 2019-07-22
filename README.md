[![Build Status](https://dev.azure.com/healthcatalyst/Clinical%20Decision/_apis/build/status/Text/Python%20Powershell%20Utilities?branchName=development)](https://dev.azure.com/healthcatalyst/Clinical%20Decision/_build/latest?definitionId=1111&branchName=development)

# Python Powershell Utilities

A powershell module for installing python versions and managing python virtual environments - on windows. There are several good tools available for managing python installations and virtual environments for *nix. This module aims to take the best ideas from those tools and create a tool that feels native to windows. For those times when you really can't, unfortunately, just use linux.

> If you are looking for the documentation for version 1.x please see [the wiki](https://github.com/HealthCatalyst/PythonPowershellUtilities/wiki/Version-1-Documentation).

## Installation
```powershell
Install-Module PythonPowershellUtilities
```
The module is hosted on [powershellgallery.com](https://www.powershellgallery.com/packages/PythonPowershellUtilities) and can be downloaded and installed using the powershell `Install-Module` command.

## Overview
This module makes it easy to download multiple versions of python into a single configurable location. It also makes it easy to create and manage virtual environments that point to any of those installations. For example, to install Python version 3.7.2, create a virtual environment, and then activate that environment you would run

```powershell
Install-Python 3.7.2
New-PythonVirtualEnvironment -ShortVersion 3.7 -Name MyEnvironment
Enter-PythonVirtualEnvironment MyEnvironment
```

By default this tool appends the python version to every environment name. So the code above would create a virtual environment named `MyEnvironment-3.7`. However, when activating a virtual environment it is only necessary to include as much of the name as you need to uniquely identify your environment since behind the scenes the appropriate virtual environment is found using `EnvironmentName.StartsWith()`.


## Installation Locations
By default `Install-Python` will add a new sub-directiry inside `C:\PythonInstallations` called `python<version>` where version is the major.minor python version. For example, calling `Install-Python 3.6.8` would create the new directory `C:\PythonInstallations\python3.6`. Similarly, `New-PythonVirtualEnvironment` will create new environments in `C:\PythonVirtualEnvironments` by default. For example, calling `New-PythonVirtualEnvironment -Name MyEnvironment -ShortVersion 3.7` will create a new virtual environment named `MyEnvironment-3.7` in `C:\PythonVirtualEnvironments` (which can then be activated by calling `Enter-PythonVirtualEnvironment MyEnvironment`). 

### Changing the Defaults
Both of these default locations can be managed by calling their getters and setters.

|Method                    | Description |
|--------------------------|-------------|
|Set-PythonInstallRoot     | Sets the value of `PythonInstsallRoot`, the directory into which new python versions will be installed.|
|Get-PythonInstallRoot     | Gets directory into which new python versions will be installed.|
|Set-VirtualEnvironmentRoot| Sets the value of `VirtualEnvironmentRoot`, the directory into which new virtual environments will be placed, and where the utility will look for environments when `Enter-PythonVirtualEnvironment` is called.|
|Get-VirtualEnvironmentRoot| Gets the value of `VirtualEnvironmentRoot`.|

So to set the directory where new virtual environments are created to `C:\Users\my.user\Developer`, use
```powershell
Set-VirtualEnvironmentRoot -Path "C:\Users\my.user\Developer"
```


It is recommended that if you wish to change the defaults, you do so before using the utilities to install python versions or create virtual environments. If you install python versions into one `PythonInstallRoot` and then change the value of `PythonInstallRoot` using `Set-PythonInstallRoot` the utility will uninstall all the currently-installed python versions (after prompting the user for confirmation). You will then need to re-install those versions again in the new `PythonInstallRoot` in order to create new virtual environments using those installations. Also, note that if you have created virtual environments using the versions of python that were installed in one `PythonInstallRoot`, after changing the `PythonInstallRoot` those virtual environments will be orphaned, meaning that they will still exist, but you will not be able to execute any python code using those environments. Similarly, if you change the `VirtualEnvironmentRoot` after creating virtual environments in the old `VirtualEnvironmentRoot`, the old virtual environments will still exist, and they *can* still be executed, but they cannot be accessed by calling `Enter-PythonVirtualEnvironment` since the utilities are now pointed at the new `VirtualEnvironmentRoot`.


## Updating Installed Versions
While it is possible to install multiple major.minor versions of python on the same windows machine, it is not possible to install multiple patch versions of the same major.minor version. For example, you can install `3.5.7`, `3.6.8`, and `3.7.2` all on the same machine becuase they are different minor versions. However, if you try to install version `3.7.3` alongside version `3.7.2` the new installation will delete the `3.7.2` executable. In light of this fact, if you wish to upgrade from `3.7.2` to `3.7.3` for example, call `Update-Python -ShortVersion 3.7 -NewFullVersion 3.7.3`. This will remove the previously installed version of `3.7` and install the version you specify as `-NewFullVersion`, in this case `3.7.3`. This means that any virtual environments created using `-ShortVersion 3.7` will now point to `3.7.3` instead of `3.7.2`, allowing you to upgrade your python installations without needing to re-create your virtual environments (this is because the venvs are created using the `--symlinks` flag). Note that you may also use `Update-Python` to roll-back to an earlier patch version. For example, calling `Update-Python 3.7 3.7.1` when `3.7.2` is installed will remove `3.7.2` and install `3.7.1`.

## Uninstalling Python Versions
To uninstall a previously-installed version of python execute `Uninstall-Python -Version <version>` where `<version>` can be either the full version, e.g. `3.7.2` or the short version, `3.7`. 

The same executable is used to both install and uninstall python. This module caches the installer/uninstaller executable every time a new version of python is installed through `Install-Python` and then uses that executable to uninstall the corresponding version of python. The executable is deleted once the version is uninstalled.

## Why Can't I Use this Tool to Install Version 2.x?
For python version 3.x the python development team provides several installers for windows, one of which is an executable installer that can be run from the command line / powershell. This is the installer that these utilities use. However, for version 2.x the development team only offers a gui-based MSI installer which cannot be run from Powershell, as far as I am aware. So in order to keep things simple, and in light of the fact that most people consider python version 2.x to be deprecated anyway, these utilities only support version 3.x.


## API Changes from Version 1
1. The `-Version` parameter of `Install-Python` has been renamed to `-FullVersion` to emphasize that it should be the major.minor.patch version, not the short version.
1. The `-Version` parameter of `New-PythonVirtualEnvironment` has been renamed to `-ShortVersion` to emphasize that it should be the major.minor version, not the full verison.
1. The `Update-Python` function was added to allow easy updating of existing major.minor versions and to emphasize the fact that you cannot install multiple patch versions at once.
1. Calling `Install-Python` and `New-PythonVirtualEnvironment` now creates folders that end in just the major.minor version instead of the full version.



# API

## Managing Python Installations
### Install-Python
This will install a new version of python in whatever location is returned by a call to `Get-PythonInstallRoot` which defaults to `C:\PythonInstallations\`. This involves downloading the specified version of python from `https://www.python.org/ftp/python/` and running the installer. As such, you must be an administrator to run this command. 
```powershell
Install-Python -FullVersion 3.6.8
```
This command can be used to install [any 3.x version that has an installer on `python.org`](https://www.python.org/downloads/windows/), but the major, minor, and patch numbers must all be specified. For example, specifying `-FullVersion 3.6.8` will work, but `-FullVersion 3.6` will not.

This command will cache the installer executable to use it to uninstall its corresponding version of python upon a call to `Uninstall-Python`.

### Get-InstalledPythonVersions
Lists the version numbers that are currently installed.

### Update-Python
This will update the specified `ShortVersion` to the `NewFullVersion`. For example, if version `3.6.5` is currently installed
```powershell
Update-Python -ShortVersion 3.6 -NewFullVersion 3.6.8
```
will remove version `3.6.5` and install version `3.6.8`. This will also mean that any virtual environment that was pointing to python `3.6.5` will now be pointing to `3.6.8` automatically.

### Uninstall-Python
This will uninstall the specified version of python and delete the corresponding installer executable.
```powershell
Uninstall-Python -Version 3.6.8
```

***

## Managing Virtual Environments
### New-PythonVirtualEnvironment
Creates a new virtual environment using the specified version of python, and gives it the specified name.
```powershell
New-PythonVirtualEnvironment -ShortVersion 3.6 -Name FirstEnv
```
This will create a new virtual environment in whatever location is returned by a call to `Get-VirtualEnvironmentRoot` which defaults to `C:\PythonVirtualEnvironments`. This command automatically appends the python short version to the name of the virtual environment, so the example above would create a virtual environment named `FirstEnv-3.6`.

Attempting to create two virtual environments with the same name and same version of python will produce an error.

### Enter-PythonVirtualEnvironment
Activates the specified virtual environment.
```powershell
Enter-PythonVirtualEnvironment -Name FirstEnv
```
To exit the virtual environment, execute `deactivate` in your powershell session.
The `-Name` parameter only needs to be as much of the first part of the environment name as is necessary to uniquely identify it. For example, if you had two environments, one named `EnvironmentOne` and another named `EnvironmentTwo`, you would only need to type `-Name EnvironmentO` to specify `EnvironmentOne`, or `-Name EnvironmentT` to specify `EnvironmentTwo`. The `-Name` parameter is case sensitive.

### Remove-PythonVirtualEnvironment
Removes the specified virtual environment. For example, assuming that there exists a virtual environment named MyEnvironment
```powershell
Remove-PythonVirtualEnvironment MyEnvironment
```
will delete that environment after prompting for confirmation. Specifying the `-YesToAll` flag will force removal of the environment without prompting for confirmation. Note that when deleting an environment it is only necessary to specify as much of the environment name as you need to in order to uniquely identify it.

### Get-PythonVirtualEnvironments
Lists all the virtual environments that have been created.

***

## Getting and Setting Config Values
### Get-PythonInstallRoot
Prints the directory into which new python versions will be installed. For example,
```powershell
Get-PythonInstallRoot
```
returns the value of `C:\PythonInstallations` if it has not been changed through a call to `Set-PythonInstallRoot`.

### Set-PythonInstallRoot
Sets the directory into which new python versions will be installed. For example, after calling
```powershell
Set-PythonInstallRoot -Path 'C:\Program Files\PythonInstallations'
```
any calls to `Install-Python` will install python versions into `C:\Program Files\PythonInstallations`.

It is highly recommended that if you wish to change the default location into which python versions are installed you do so before actually installing any versions. i.e. make sure to call `Set-PythonInstallRoot` before making any calls to `Install-Python`. If you attempt to set a new installation location after one or more versions of python are already installed, all existing versions of python will be uninstalled (after prompting you) and you will need to reinstall them in the new location. Additionally, any virtual environments that were created before changing the installation directory will be orphaned, meaning they will still exist but you will not be able to execute any python code using those environments unless you re-install python into the same location it was when the environment was created. This is because the python executable that is present in a python virtual environment is effectively a symbolic link to the python executable used to create the environment. If you remove the executable used to create the environment the link is no longer valid.


### Get-VirtualEnvironmentRoot
Gets the directory into which new python virtual environments will be placed when `New-PythonVirtualEnvironment` is called.
```powershell
Get-VirtualEnvironmentRoot
```

### Set-VirtualEnvironmentRoot
Sets the directory into which new python virtual environments will be placed when `New-PythonVirtualEnvironment` is called. For example, after calling
```powershell
Set-VirtualEnvironmentRoot -Path 'C:\Program Files\PythonVirtualEnvironments'
```
any new environment created using `New-PythonVirtualEnvironment` will be placed in `C:\Program Files\PythonVirtualEnvironments`.

Please note that if you change the virtual environment directory after creating virtual environments, the existing environments will still remain as valid environments, however you will not be able to activate them through calls to `Enter-PythonVirtualEnvironment` since the utilities will be pointed at the new virtual environment directory. However, they may still be activated by running their activation script in `<virtualEnvironment>\Scripts\Activate.ps1`.

### Restore-PythonUtilitiesConfigDefaults
Restores the configuration default values to those listed in the Readme.
```powershell
Restore-PythonUtilitiesConfigDefaults
```