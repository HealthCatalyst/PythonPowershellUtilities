function Update-Python([string]$ShortVersion, [string]$NewFullVersion){
    $newShortVersion = Convert-FullVersionToShortVersion $NewFullVersion
    if (!($ShortVersion -eq $newShortVersion)){
        throw "This function may only be used to update the patch version of a python installation, i.e. the major.minor version of the NewFullVersion must match the specified short version. Got $ShortVersion for the existing installation and $NewFullVersion for the desired new version. If you want to install a new major.minor version of python please use 'Install-Python'."
    }
    $oldFullVersion = Convert-ShortVersionToFullVersion $ShortVersion
    if (!$oldFullVersion){
        throw "Python version $ShortVersion is not installed. Please use 'Install-Python $NewFullVersion' to install it. Or call 'Get-InstalledPythonVersions' to see a list of all installed versions."
    }
    Uninstall-Python $oldFullVersion
    Install-Python $NewFullVersion
}