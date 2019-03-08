. "$PSScriptRoot\Get-PythonUtilitiesConfigValue.ps1"

function New-PythonVirtualEnvironment([string]$Version, [string]$Name){
    $installRoot = Get-PythonUtilitiesConfigValue -Key 'PythonInstallRoot'
    $virtualenvRoot = Get-PythonUtilitiesConfigValue -Key 'VirtualEnvironmentDirectory'
    $pythonEXEPath = "$installRoot\python$Version\python.exe"
    $virtualEnvPath = "$virtualenvRoot$Name-$Version"

    if(!(Test-Path -Path $InstallRoot)){
        New-Item -ItemType directory -Path $InstallRoot
    }

    Write-Host "Creating new virtual environment for Python version $Version at $virtualEnvPath."
    & $pythonEXEPath -m venv $virtualEnvPath | Out-Null
}