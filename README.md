[![Build Status](https://healthcatalyst.visualstudio.com/Clinical%20Decision/_apis/build/status/Text/Python%20Powershell%20Utilities?branchName=development)](https://healthcatalyst.visualstudio.com/Clinical%20Decision/_build/latest?definitionId=1055&branchName=development)

# Python Powershell Utilities

A powershell module for installing python versions and managing python virtual environments.

## Overview
This module makes it easy to download multiple versions of python into a single configurable location. It also makes it easy to create and manage virtual environments that point to any of those installations. For example, to install Python version 3.7.2, create a virtual environment, and then activate that environment you would run

```powershell
Install-Python 3.7.2
New-PythonVirtualEnvironment -Version 3.7.2 -Name MyEnvironment
Enter-PythonVirtualEnvironment MyEnvironment
```

By default this tool appends the python version to every environment name. So the code above would create a virtual environment named `MyEnvironment-3.7.2`. However, when activating a virtual environment it is only necessary to include as much of the name as you need to uniquely identify your environment since behind the scenes the appropriate virtual environment is found using `EnvironmentName.StartsWith()`.

**See the Wiki tab for an API reference.**


## Installation Locations
By default `Install-Python` will add a new sub-directiry inside `C:\PythonInstallations` called `python<version>` where version is the major.minor.patch python version. For example, calling `Install-Python 3.6.8` would create the new directory `C:\PythonInstallations\python3.6.8`. Similarly, `New-PythonVirtualEnvironment` will create new environments in `C:\PythonVirtualEnvironments` by default. For example, calling `New-PythonVirtualEnvironment -Name MyEnvironment -Version 3.7.1` will create a new virtual environment named `MyEnvironment-3.7.1` in `C:\PythonVirtualEnvironments` (which can then be activated by calling `Enter-PythonVirtualEnvironment MyEnvironment`). 

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

## Why Can't I Use this Tool to Install Version 2.x?
For python version 3.x the python development team provides several installers for windows, one of which is an executable installer that can be run from the command line / powershell. This is the installer that these utilities use. However, for version 2.x the development team only offers a gui-based MSI installer which cannot be run from Powershell, as far as I am aware. So in order to keep things simple, and in light of the fact that most people consider python version 2.x to be deprecated anyway, these utilities only support version 3.x.

## Uninstalling Python Versions
To uninstall a previously-installed version of python execute `Uninstall-Python -Version <version>` where `<version>` is the three-number version, e.g. `3.7.2`. 

The same executable is used to both install and uninstall python. This module caches the installer/uninstaller executable every time a new version of python is installed through `Install-Python` and then uses that executable to uninstall the corresponding version of python. The executable is deleted once the version is uninstalled.
