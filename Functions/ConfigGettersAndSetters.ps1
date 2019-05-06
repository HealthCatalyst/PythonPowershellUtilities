. "$PSScriptRoot\Get-InstalledPythonVersions.ps1"
. "$PSScriptRoot\Uninstall-Python.ps1"

$script:registryConfigPath = "HKLM:\SOFTWARE\PythonPowershellUtilities"

function Get-PythonUtilitiesConfigValue([string]$Key){
$Null = @(
    # Add registry keys if they haven't been added already, otherwise just return them
    if (!(Test-Path $script:registryConfigPath)){
        New-Item -Path $script:registryConfigPath
        Set-PythonUtilitiesConfigValue -Key "PythonInstallRoot" -Value "C:\PythonInstallations"
        Set-PythonUtilitiesConfigValue -Key "VirtualEnvironmentRoot" -Value "C:\PythonVirtualEnvironments"
    }
    $entry = Get-ItemProperty $script:registryConfigPath -Name $Key
)
    return $entry.$Key
}

function Set-PythonUtilitiesConfigValue([string]$Key, [string]$Value){
$Null = @(
    Set-ItemProperty -Path $script:registryConfigPath -Name $Key -Value $Value > $null
)
}

function Get-PythonInstallerCache(){
$Null = @(
    $installRoot = Get-PythonInstallRoot
    $installerCache = "$installRoot\Installers"
    if (!(Test-Path $installerCache)){
        New-Item -ItemType Directory -Path $installerCache -Force > $null
    }
)
    return $installerCache
}

function Get-PythonInstallRoot(){
    return Get-PythonUtilitiesConfigValue -Key "PythonInstallRoot"
}

function Set-PythonInstallRoot([string]$Path, [switch]$Force=$false){
$Null = @(
    $installRoot = Get-PythonInstallRoot
    $installedVersions = Get-InstalledPythonVersions
    if ($installedVersions.Count -gt 0){
        if (!$Force){
            $response = Read-Host "WARNING: One or more versions of python have already been installed into the current PythonInstallRoot located at $installRoot. Changing the root will uninstall those versions and orphan any virtual environments created from those versions. To continue and uninstall the current python versions enter 'yes'. To cancel, enter 'no' or press enter/return"
            if (!($response -eq "yes")){
                return
            }
        }
        
        foreach ($version in $(Get-InstalledPythonVersions)){
            Uninstall-Python -Version $version
        }
        
        $installerCache = Get-PythonInstallerCache
        if (Test-Path -Path $installerCache){
            # Delete the installer cache and the installation directory if it's empty
            Remove-Item -Recurse $installerCache
            $installerDirInfo = Get-ChildItem $installRoot | Measure-Object
            if ($installerDirInfo.Count -eq 0){
                Remove-Item -Recurse $installRoot
            }
        }
    }
    New-Item -ItemType directory -Path "$Path\Installers" -Force
    Set-PythonUtilitiesConfigValue -Key "PythonInstallRoot" -Value $Path
)
}

function Get-VirtualEnvironmentRoot(){
    return Get-PythonUtilitiesConfigValue -Key "VirtualEnvironmentRoot"
}

function Set-VirtualEnvironmentRoot([string]$Path, [switch]$Force){
$Null = @(
    if (!$Force){
        $venvRootPath = Get-VirtualEnvironmentRoot
        if (Test-Path $venvRootPath) {
            $venvRootInfo = Get-ChildItem $venvRootPath | Measure-Object
            if ($venvRootInfo.Count -gt 0){
                $response = Read-Host "WARNING: One or more virtual environments have already been created in the current VirtualEnvironmentRoot, located at $venvRootPath. Changing the root will leave the environments in place, but they will not be accessible through calls to `Enter-PythonVirtualEnvironment`. To continue enter 'yes'. To cancel, enter 'no' or press enter/return"
                if (!($response -eq "yes")){
                    return
                }
            }
        }
    }
    Set-PythonUtilitiesConfigValue -Key "VirtualEnvironmentRoot" -Value $Path
)
}