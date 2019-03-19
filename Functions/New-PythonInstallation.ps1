. "$PSScriptRoot\Get-PythonUtilitiesConfigValue.ps1"
. "$PSScriptRoot\Get-PythonInstallerUrl.ps1"

function New-PythonInstallation([string]$Version, [bool]$DeleteInstaller=$false){
    $installerUrl = Get-PythonInstallerUrl -Version $Version
    $installRoot = Get-PythonUtilitiesConfigValue -Key 'PythonInstallRoot'
    $installName = "python$Version"
    $installerEXEPath = "$PSScriptRoot\$installName-Installer.exe"

    if (!($Version -match "^\d+\.\d+\.\d+$")){
        throw "Version must be fully specified. e.g. '3.7' will not work, but '3.7.2' will."
    }
    if($Version -match "^2\."){
        throw "Unfortunately there are no executable installers for python versions 2.x. Version 2.x must be installed manually from https://www.python.org/downloads/"
    }

    Write-Host "Downloading Python Installer..."
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $installerURL -OutFile $installerEXEPath
    
    if(!(Test-Path -Path $installRoot)){
        New-Item -ItemType directory -Path $installRoot
    }
    
    # Wait for executable to complete so we can delete it when we are done
    $result = Start-Process $installerEXEPath -ArgumentList "/quiet /passive InstallAllUsers=1 TargetDir=$installRoot\$installName" -NoNewWindow -Wait -PassThru
    if (!($result.ExitCode -eq 0)) {
        throw "Python installation failed."
    }
    
    if ($DeleteInstaller){
        Write-Host "Deleting the installer executable at $installerEXEPath..."
        Remove-Item -Path $installerEXEPath
    }
}