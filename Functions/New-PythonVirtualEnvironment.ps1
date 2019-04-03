. "$PSScriptRoot\ConfigGettersAndSetters.ps1"

function New-PythonVirtualEnvironment([string]$Version, [string]$Name){
$Null = @(
    $installRoot = Get-PythonInstallRoot
    $virtualenvRoot = Get-VirtualEnvironmentRoot
    $pythonEXEPath = "$installRoot\python$Version\python.exe"
    $virtualEnvPath = [io.path]::Combine($virtualenvRoot, "$Name-$Version")

    if(!(Test-Path -Path $pythonEXEPath)){
        throw "Python version $Version is not installed. Please execute `Install-Python $Version` to install it and then re-run this command."
    }

    if(!(Test-Path -Path $InstallRoot)){
        New-Item -ItemType directory -Path $InstallRoot
    }

    Write-Host "Creating new virtual environment for Python version $Version at $virtualEnvPath."
    $result = Start-Process $pythonEXEPath -ArgumentList "-m venv `"$virtualEnvPath`"" -NoNewWindow -Wait -PassThru
    if (!($result.ExitCode -eq 0)) {
        throw "Error creating virtual environment."
    }
)
}