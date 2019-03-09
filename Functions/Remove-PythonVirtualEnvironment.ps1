. "$PSScriptRoot\Get-PythonUtilitiesConfigValue.ps1"

function Remove-PythonVirtualEnvironment([string]$Name, [switch]$YesToAll=$false){
    $virtualenvRoot = Get-PythonUtilitiesConfigValue -Key 'VirtualEnvironmentRoot'

    #Find matching virtualenv
    $virtualEnvs = Get-ChildItem $virtualenvRoot -Directory
    foreach ($environmentPath in $virtualEnvs){
        $environmentName = $environmentPath.Name
        if ($environmentName.StartsWith($Name)){
            if (!$YesToAll){
                $delete = Read-Host -Prompt "Delete virtual environment at $virtualenvRoot\$environmentName? y/n"
                if (!$delete -or ($delete.ToLower() -ne "y")) {return}
            }
            Remove-Item -LiteralPath "$virtualenvRoot\$environmentName" -Force -Recurse
            return
        }
    }

    throw "Could not find a virtual environment in $virtualenvRoot whose name starts with $Name."
}