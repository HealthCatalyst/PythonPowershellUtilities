function Remove-PythonInstallation([string]$Version){
    $installerCache = "$PSScriptRoot\..\Installers"
    $installName = "python$Version"
    $installerEXEPath = "$installerCache\$installName-Installer.exe"

    if (!(Test-Path -Path $installerEXEPath)){
        throw "Could not find an installer for python version $Version. (The installer is also used to uninstall python). This happens when the installer executable was deleted before using it to uninstall its corresponding version of python. Please attempt an uninstall using the system 'Apps & Features'. If this does not work, download the installer corresponding to your python version from https://www.python.org/downloads/windows/ and use it to repair the installation before uninstalling."
    }

    # Wait for executable to complete so we can delete it when we are done
    $result = Start-Process $installerEXEPath -ArgumentList "/uninstall /passive" -NoNewWindow -Wait -PassThru
    if (!($result.ExitCode -eq 0)) {
        throw "Python installer crashed silently while uninstalling."
    }

    Remove-Item -Path $installerEXEPath
}