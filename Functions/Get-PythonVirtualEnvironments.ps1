. "$PSScriptRoot\Get-PythonUtilitiesConfigValue.ps1"

function Get-PythonVirtualEnvironments(){
    $virtualenvRoot = Get-PythonUtilitiesConfigValue -Key 'VirtualEnvironmentRoot'

    foreach ($item in Get-ChildItem $virtualenvRoot -Directory) {
        $name = $item.Name
        Write-Host $name
    }
}