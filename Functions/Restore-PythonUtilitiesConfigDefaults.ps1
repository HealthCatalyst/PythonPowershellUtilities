. "$PSScriptRoot\ConfigGettersAndSetters.ps1"

function Restore-PythonUtilitiesConfigDefaults(){
    Set-PythonInstallRoot -Value "C:\PythonInstallations\"
    Set-VirtualEnvironmentRoot -Value "C:\PythonVirtualEnvironments\"
}