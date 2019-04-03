. "$PSScriptRoot\ConfigGettersAndSetters.ps1"

function Restore-PythonUtilitiesConfigDefaults([switch]$Force){
$Null = @(
    if ($Force){
        Set-PythonInstallRoot -Path "C:\PythonInstallations\" -Force
        Set-VirtualEnvironmentRoot -Path "C:\PythonVirtualEnvironments\" -Force
    }
    else {
        Set-PythonInstallRoot -Path "C:\PythonInstallations\"
        Set-VirtualEnvironmentRoot -Path "C:\PythonVirtualEnvironments\"
    }
)
}