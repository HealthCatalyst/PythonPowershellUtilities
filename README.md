# Python Powershell Utilities

A powershell module for installing python versions and managing python virtual environments.

## Overview
This module makes it easy to download multiple versions of python into single configurable location. It also makes it easy to create and manage virtual environments that point to any of those installations. For example, to install Python version 3.7.2, create a virtual environment, and then activate that environment you would run

```powershell
New-PythonInstallation 3.7.2
New-PythonVirtualEnvironment -Version 3.7.2 -Name MyEnvironment
Enter-PythonVirtualEnvironment MyEnvironment
```

By default this tool appends the python version to every environment name. So the code above would create a virtual environment named `MyEnvironment-3.7.2`. However, when activating a virtual environment it is only necessary to include as much of the name as you need to uniquely identify your environment since behind the scenes the appropriate virtual environment is found using `EnvironmentName.StartsWith()`.