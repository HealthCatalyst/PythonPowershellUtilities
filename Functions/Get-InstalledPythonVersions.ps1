
function Get-InstalledPythonVersions(){
    $installerCache = "$PSScriptRoot\..\Installers"
    $versionRegex = "python(?<version>\d{1,2}.\d{1,2}.\d{1,2})-Installer.exe"
    $installedVersions = New-Object System.Collections.ArrayList

    foreach ($pathObj in Get-ChildItem "$installRoot\python*"){
        $match = $pathObj.Name -match $versionRegex
        $installedVersions.add($match.version)
    }

    return $installedVersions
}