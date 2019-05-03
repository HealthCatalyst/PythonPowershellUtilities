function Uninstall-Python([string]$Version){
$Null = @(
    $parts = $Version.split('.')
    # Check if the specified version is installed, and if the short version was specified expand it to the full version.
    $installed = $true
    if ($parts.count -lt 3){
        $fullVersion = Convert-ShortVersionToFullVersion $Version
        if (!$fullVersion){
            $installed = $false
        }
        $Version = $fullVersion
    }
    else {
        $installed = Test-FullVersionIsInstalled $Version
    }

    if (!$installed){
        throw "Python version $Version is not installed. Please use 'Install-Python' to install it. Or call 'Get-InstalledPythonVersions' to see a list of all installed versions."
    }

    $installRoot = Get-PythonInstallRoot
    $shortVersion = Convert-FullVersionToShortVersion $Version
    $installDirName = "python$shortVersion"
    $installLocation = "$installRoot/$installDirName"
    $installerEXEPath = Get-PythonInstaller $Version

    Write-Host "Uninstalling python version $shortVersion..."
    # Wait for executable to complete so we can delete it when we are done
    $result = Start-Process $installerEXEPath -ArgumentList "/uninstall /passive" -NoNewWindow -Wait -PassThru
    if (!($result.ExitCode -eq 0)) {
        throw "Python installer crashed silently while uninstalling."
    }

    Write-Host "Removing the installer executable at $installerEXEPath..."
    Remove-Item -Path $installerEXEPath
    # The folder where python was installed is removed by the installer when it finishes.
)
}