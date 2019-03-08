. "$PSScriptRoot\Get-PythonUtilitiesConfigValue.ps1"
. "$PSScriptRoot\Get-PythonInstallerUrl.ps1"

function New-PythonInstallation([string]$Version, [switch]$YesToAll=$false){
    $installerUrl = Get-PythonInstallerUrl -Version $Version
    $installRoot = Get-PythonUtilitiesConfigValue -Key 'PythonInstallRoot'
    $installName = "python$Version"
    $installerEXEPath = "$PSScriptRoot\$installName-Installer.exe"

    Write-Host "Downloading Python Installer..."
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $installerURL -OutFile $installerEXEPath
    
    if(!(Test-Path -Path $installRoot)){
        New-Item -ItemType directory -Path $installRoot
    }
    
    # Wait for executable to complete so we can delete it when we are done
    & $installerEXEPath /quiet /passive InstallAllUsers=1 TargetDir=$installRoot\$installName | Out-Null
    
    $delete = Read-Host -Prompt "Delete installer? Y/n"
    if (!$delete) {$delete = "y"}
    if (($delete.ToLower() -eq "y") -or $YesToAll){
        Remove-Item -Path $installerEXEPath
    }
}