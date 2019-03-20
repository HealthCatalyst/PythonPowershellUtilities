
function Get-InstalledPythonVersions(){
    $installerCache = "$PSScriptRoot\..\Installers"
    $versionRegex = "python(?<version>\d{1,2}.\d{1,2}.\d{1,2})-Installer.exe"
    $installedVersions = @()

    foreach ($pathObj in Get-ChildItem "$installRoot\python*"){
        $match = $pathObj.Name -match $versionRegex
        $installedVersions += $match.version
    }

    return ,$installedVersions
}