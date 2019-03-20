. "$PSScriptRoot\ConfigGettersAndSetters.ps1"

function Restore-PythonUtilitiesConfigDefaults(){
    Set-PythonInstallRoot -Path "C:\PythonInstallations\"
    Set-VirtualEnvironmentRoot -Path "C:\PythonVirtualEnvironments\"
}