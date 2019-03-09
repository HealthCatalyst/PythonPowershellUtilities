. "$PSScriptRoot\Get-PythonUtilitiesConfigValue.ps1"

function Get-InstalledPythonVersions(){
    $installRoot = Get-PythonUtilitiesConfigValue -Key 'PythonInstallRoot'
    
    Write-Host "Installed Python versions:"
    foreach ($pathObj in Get-ChildItem $installRoot){
        Write-Host $pathObj.Name.Replace("python", "")
    }
}