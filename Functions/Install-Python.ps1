. "$PSScriptRoot\ConfigGettersAndSetters.ps1"
. "$PSScriptRoot\Get-PythonInstallerUrl.ps1"

function Install-Python([string]$FullVersion){
$Null = @(
    if (!($FullVersion -match "^\d+\.\d+\.\d+$")){
        throw "Version must be fully specified. e.g. '3.7' will not work, but '3.7.2' will."
    }
    if($FullVersion -match "^2\."){
        throw "Unfortunately there are no executable installers for python versions 2.x. Version 2.x must be installed manually from https://www.python.org/downloads/"
    }
    
    $installRoot = Get-PythonInstallRoot
    $shortVersion = Convert-FullVersionToShortVersion $FullVersion
    $installDirName = "python$shortVersion"
    $installLocation = "$installRoot\$installDirName"
    $installerEXEPath = Get-PythonInstaller $FullVersion

    
    if (Test-ShortVersionIsInstalled $shortVersion){
        throw "Python version $shortVersion has already been installed, please call 'Update-Python $shortVersion -NewFullVersion $FullVersion' if you want to update the installation. Or call 'Get-InstalledPythonVersions' to see a list of all installed versions."
    }
    
    if(!(Test-Path -Path $installRoot)){
        New-Item -ItemType directory -Path $installRoot
    }
    
    $result = Start-Process $installerEXEPath -ArgumentList "/passive InstallAllUsers=1 TargetDir=`"$installLocation`"" -NoNewWindow -Wait -PassThru
    if (!($result.ExitCode -eq 0)) {
        throw "Python installation failed."
    }
)
}