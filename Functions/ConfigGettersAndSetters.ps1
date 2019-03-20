. "$PSScriptRoot\Get-InstalledPythonVersions.ps1"
. "$PSScriptRoot\Remove-PythonInstallation.ps1"

$script:configPath = "$PSScriptRoot\..\Config\config.json"

function Get-PythonUtilitiesConfigValue([string]$Key){
    $config = Get-Content -Path $script:configPath | ConvertFrom-Json
    return $config.$Key
}

function Set-PythonUtilitiesConfigValue([string]$Key, [string]$Value){
    $config = Get-Content -Path $script:configPath | ConvertFrom-Json
    $config.$Key = $Value
    $config | ConvertTo-Json | Out-File -FilePath $script:configPath
}

function Get-PythonInstallRoot(){
    return Get-PythonUtilitiesConfigValue -Key "PythonInstallRoot"
}

function Set-PythonInstallRoot([string]$Path, [switch]$Force=$false){
    $installerCache = "$PSScriptRoot\..\Installers"
    $cacheInfo = Get-ChildItem "$installerCache\python*" | Measure-Object
    if ($cacheInfo.Count -gt 0){
        if (!$Force){
            $response = Read-Host "WARNING: One or more versions of python have already been installed into the current PythonInstallRoot, changing the root will uninstalll those versions and orphan any virtual environments created from those versions. To continue and uninstall the current python versions enter 'yes'. To cancel, enter 'no' or press enter/return"
            if (!($response -eq "yes")){
                return
            }
        }
        
        foreach ($version in Get-InstalledPythonVersions){
            Remove-PythonInstallation -Version $version
        }
    }
    Set-PythonUtilitiesConfigValue -Key "PythonInstallRoot" -Value $Path
}

function Get-VirtualEnvironmentRoot(){
    return Get-PythonUtilitiesConfigValue -Key "VirtualEnvironmentRoot"
}

function Set-VirtualEnvironmentRoot([string]$Path, [switch]$Force){
    if (!$Force){
        $venvRootInfo = Get-ChildItem Get-VirtualEnvironmentRoot | Measure-Object
        if ($venvRootInfo.Count -gt 0){
            $response = Read-Host "WARNING: One or more virtual environments have already been created in the current VirtualEnvironmentRoot. Changing the root will leave the environments in place, but they will not be accessible through calls to `Enter-PythonVirtualEnvironment`. To continue enter 'yes'. To cancel, enter 'no' or press enter/return"
            if (!($response -eq "yes")){
                return
            }
        }
    }
    Set-PythonUtilitiesConfigValue -Key "VirtualEnvironmentRoot" -Value $Path
}