. "$PSScriptRoot\Get-PythonUtilitiesConfigValue.ps1"

function Enter-PythonVirtualEnvironment([string]$Name){
    $virtualenvRoot = Get-PythonUtilitiesConfigValue -Key 'VirtualEnvironmentRoot'

    #Find matching virtualenv
    $virtualEnvs = Get-ChildItems $virtualenvRoot -Directory
    foreach ($environmentPath in $virtualEnvs){
        $environmentName = $environmentPath.Name
        if ($environmentName.StartsWith($Name)){
            Invoke-Expression -Command "$virtualenvRoot\$environmentName\Scripts\Activate.ps1"
            return
        }
    }

    throw "Could not find a virtual environment in $virtualenvRoot whose name starts with $Name."
}