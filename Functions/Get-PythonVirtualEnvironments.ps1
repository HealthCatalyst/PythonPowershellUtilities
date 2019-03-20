. "$PSScriptRoot\ConfigGettersAndSetters.ps1"

function Get-PythonVirtualEnvironments(){
    $virtualenvRoot = Get-VirtualEnvironmentRoot
    $virtualEnvironments = @()
    foreach ($item in Get-ChildItem $virtualenvRoot -Directory) {
        $virtualEnvironments += $item.Name
    }

    return $virtualEnvironments
}