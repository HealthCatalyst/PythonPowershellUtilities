. "$PSScriptRoot\Set-PythonUtilitiesConfigValue.ps1"

function Restore-PythonUtilitiesConfigDefaults(){
    Set-PythonUtilitiesConfigValue -Key "PythonInstallRoot" -Value "C:\PythonInstallations\"
    Set-PythonUtilitiesConfigValue -Key "VirtualEnvironmentRoot" -Value "C:\PythonVirtualEnvironments\"
}