. "$PSScriptRoot\ConfigGettersAndSetters.ps1"

function Enter-PythonVirtualEnvironment([string]$Name){
    $virtualenvRoot = Get-VirtualEnvironmentRoot

    #Find matching virtualenv
    $virtualEnvs = Get-ChildItem $virtualenvRoot -Directory
    foreach ($environmentPath in $virtualEnvs){
        $environmentName = $environmentPath.Name
        if ($environmentName.StartsWith($Name)){
            Write-Host "To exit the virtual environment execute the command, 'deactivate'."
            $activationPath = "$virtualenvRoot\$environmentName\Scripts\Activate.ps1" -replace ' ','` '
            Invoke-Expression -Command $activationPath
            return
        }
    }

    throw "Could not find a virtual environment in $virtualenvRoot whose name starts with $Name."
}