function Get-InstalledPythonVersions(){
$Null = @(
    $installationRoot = Get-PythonInstallRoot
    $versionRegex = ".*(?<version>\d+.\d+.\d+)"
    $installedVersions = @()

    if (Test-path -Path $installationRoot){
        foreach ($pathObj in Get-ChildItem "$installationRoot\python*"){
            $output = Invoke-Expression "& `"$($pathObj.Fullname)\python.exe`" --version"
            $output -match $versionRegex
            $installedVersions += $Matches.version
        }
    }
)
    return ,$installedVersions
}