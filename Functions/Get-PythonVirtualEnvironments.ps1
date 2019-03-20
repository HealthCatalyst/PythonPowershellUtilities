. "$PSScriptRoot\ConfigGettersAndSetters.ps1"

function Get-PythonVirtualEnvironments(){
    $virtualenvRoot = Get-VirtualEnvironmentRoot
    $virtualEnvironments = New-Object System.Collections.ArrayList

    foreach ($item in Get-ChildItem $virtualenvRoot -Directory) {
        $name = $item.Name
        $virtualEnvironments.add($name)
    }

    return $virtualEnvironments
}