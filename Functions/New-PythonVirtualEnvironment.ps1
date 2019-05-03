. "$PSScriptRoot\ConfigGettersAndSetters.ps1"

function New-PythonVirtualEnvironment([string]$ShortVersion, [string]$Name){
$Null = @(
    if ($ShortVersion.split('.').count -eq 3){
        Write-Warning "It is only necessary to specify the major.minor version of the python version that you wish to use to create the virtual environment. This is because only one patch version of a given major.minor version can be installed at at time, so the patch version used for the venv will be whatever is currently installed in the location returned by `Get-PythonInstallRoot`."
        $ShortVersion = Convert-FullVersionToShortVersion $ShortVersion
    }
    $installRoot = Get-PythonInstallRoot
    $virtualenvRoot = Get-VirtualEnvironmentRoot
    $pythonEXEPath = "$installRoot\python$ShortVersion\python.exe"
    $virtualEnvPath = [io.path]::Combine($virtualenvRoot, "$Name-$ShortVersion")

    if(!(Test-ShortVersionIsInstalled $ShortVersion)){
        throw "Python version $ShortVersion is not installed. Please use `Install-Python` to install it and then re-run this command."
    }
    if (Test-Path -Path $virtualEnvPath){
        throw "A virtual environment with this name and python version already exists. Please use `Get-PythonVirtualEnvironments` to see a list of existing environments."
    }

    Write-Host "Creating new virtual environment for Python version $ShortVersion at $virtualEnvPath."
    $result = Start-Process $pythonEXEPath -ArgumentList "-m venv `"$virtualEnvPath`" --symlinks" -NoNewWindow -Wait -PassThru
    if (!($result.ExitCode -eq 0)) {
        throw "Error creating virtual environment."
    }
)
}