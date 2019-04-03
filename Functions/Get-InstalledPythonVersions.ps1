function Get-InstalledPythonVersions(){
    $installerCache = Get-PythonInstallerCache
    $versionRegex = "python(?<version>\d+.\d+.\d+)-Installer.exe"
    $installedVersions = @()

    foreach ($pathObj in Get-ChildItem "$installerCache\python*"){
        $pathObj.Name -match $versionRegex > $null
        $installedVersions += $Matches.version
    }

    return ,$installedVersions
}