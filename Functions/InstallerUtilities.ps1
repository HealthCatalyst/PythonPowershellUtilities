. "$PSScriptRoot\Get-PythonInstallerUrl.ps1"

function Get-PythonInstaller([string]$FullVersion) {
    # Returns the path to the installer for that version, downloading it if it isn't already cached.
$Null = @(
    $installerCache = Get-PythonInstallerCache
    $installerName = "python$($FullVersion)-Installer.exe"
    $installerEXEPath = "$installerCache\$installerName"
    if (!(Test-Path -Path $installerEXEPath)){
        $installerUrl = Get-PythonInstallerUrl -Version $FullVersion
        Write-Host "Downloading Python $FullVersion Installer..."
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $wc = New-Object System.Net.WebClient
        $wc.DownloadFile($installerUrl, $installerEXEPath)
    }
)
    return $installerEXEPath
}


function Remove-PythonInstaller([string]$FullVersion) {
$Null = @(
    $installerCache = Get-PythonInstallerCache
    $installerName = "python$($FullVersion)-Installer.exe"
    $installerEXEPath = "$installerCache\$installerName"
    if (Test-Path -Path $installerEXEPath){
        Remove-Item -Path $installerEXEPath -Force
    }
    else {
        Write-Warning "Could not find an installer for python version $FullVersion."
    }
)
}

