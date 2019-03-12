# Python Powershell Utilities

A powershell module for installing python versions and managing python virtual environments.

## Overview
This module makes it easy to download multiple versions of python into a single configurable location. It also makes it easy to create and manage virtual environments that point to any of those installations. For example, to install Python version 3.7.2, create a virtual environment, and then activate that environment you would run

```powershell
New-PythonInstallation 3.7.2
New-PythonVirtualEnvironment -Version 3.7.2 -Name MyEnvironment
Enter-PythonVirtualEnvironment MyEnvironment
```

By default this tool appends the python version to every environment name. So the code above would create a virtual environment named `MyEnvironment-3.7.2`. However, when activating a virtual environment it is only necessary to include as much of the name as you need to uniquely identify your environment since behind the scenes the appropriate virtual environment is found using `EnvironmentName.StartsWith()`.

**See the Wiki tab for an API reference.**


## Installation Locations
By default `New-PythonInstallation` will add a new sub-directiry inside `C:\PythonInstallations` called `python<version>` where version is the major.minor.patch python version. For example, calling `New-PythonInstallation 3.6.8` would create the new directory `C:\PythonInstallations\python3.6.8`. Similarly, `New-PythonVirtualEnvironment` will create new environments in `C:\PythonVirtualEnvironments` by default. For example, calling `New-PythonVirtualEnvironment -Name MyEnvironment -Version 3.7.1` will create a new virtual environment named `MyEnvironment-3.7.1` in `C:\PythonVirtualEnvironments` (which can then be activated by calling `Enter-PythonVirtualEnvironment MyEnvironment`). 

### Changing the Defaults
Both of these default locations can be changed by calling another function in this module `Set-PythonUtillitiesConfigValue` which takes two arguments, `-Key` and `-Value`. Here is a list of valid configuration keys which can be set using this function.

|Key                   |Default Value                 | Description |
|----------------------|------------------------------|-------------|
|PythonInstallRoot     |C:\PythonInstallations\       | The directory into which new python versions will be installed.|
|VirtualEnvironmentRoot|C:\PythonVirtualEnvironments\ | The directory into which new virtual environments will be placed, and where the utility will look for environments when `Enter-PythonVirtualEnvironment` is called.|


So to set the directory where new virtual environments are created to `C:\Users\my.user\Developer`, use
```powershell
Set-PythonUtilitiesConfigValue -Key VirtualEnvironmentRoot -Value "C:\Users\my.user\Developer"
```
Similarly, to obtain the current value for a configuration key, use `Get-PythonUtilitiesConfigValue` which takes one argument, `-Key`. The defaults are stored in a JSON file in the module directory. `Get-PythonUtilitiesConfigValue` and `Set-PythonUtilitiesConfigValue` simply read and write values to and from this file.


It is recommended that if you wish to change the defaults, you do so before using the utilities to install python versions or create virtual environments. If you install python versions into one directory and then change the default installation directory, the utility will forget that those versions were installed, since they are not present in the new directory, and you will need to re-install those versions again in the new directory in order to create new virtual environments using those installations. Similarly, if you change the default virtual environment directory after creating virtual environments in the old directory, the old virtual environments will still exist, but cannot be accessed by calling `Enter-PythonVirtualEnvironment` since the utilities are now pointed at the new directory.

## Why Can't I Use this Tool to Install Version 2.x?
For python version 3.x the python development team provides several installers for windows, one of which is an executable installer that can be run from the command line / powershell. This is the installer that these utilities use. However, for version 2.x the development team only offers a gui-based MSI installer which cannot be run from Powershell, as far as I am aware. So in order to keep things simple, and in light of the fact that most people consider python version 2.x to be deprecated anyway, these utilities only support version 3.x.

## Uninstalling Python Versions
There is currently no function in these utilties for uninstalling python versions. This is due to the fact that while the executable installers make it easy to uninstall from the GUI, there is no obvious way to use the executable installer to uninstall python from a powershell script. If you wish to uninstall a previously-installed version of python there are two paths. First, if you chose not to delete the installer executable after running `New-PythonInstallation` you can open the installer for the version of python that you wish to uninstall and following the uninstall options in the UI. If the installer executables where not deleted during installation they can be found in the directory where the `PythonPowershellUtilities` module was installed, which by default is `C:\Program Files\WindowsPowerShell\Modules\`. The executables will be in the `Functions` directory inside the module. 
