Describe "Installing new python versions and creating virtual environments" -Tag "Unit" {
    Import-Module "$PSScriptRoot\..\PythonPowershellUtilities.psm1" -Force

    
    New-PythonInstallation -Version 3.7.2 -YesToAll | Out-Null
    $installRoot = Get-PythonUtilitiesConfigValue "PythonInstallRoot"
    It 'Should create a new python 3.7.2 installation' {
        Test-Path -Path "$installRoot\python3.7.2\python.exe" | Should -BeTrue
    }

    $venvName = "TestEnv"
    $venvRoot = Get-PythonUtilitiesConfigValue "VirtualEnvironmentRoot"
    New-PythonVirtualEnvironment -Version 3.7.2 -Name $venvName | Out-Null
    It 'Should create a new virtual environment' {
        Test-Path -Path "$venvRoot\$venvName-3.7.2\Scripts\python.exe" | Should -BeTrue
    }

    Enter-PythonVirtualEnvironment -Name $venvName | Out-Null
    pip --disable-pip-version-check install toolz
    It 'Should install the test dependency into the new venv' {
        Test-Path -Path "$venvRoot\$venvName-3.7.2\Lib\site-packages\toolz" | Should -BeTrue
    }

    deactivate

    Remove-PythonVirtualEnvironment -Name $venvName -YesToAll | Out-Null
    It 'Should delete the newly-created venv' {
        Test-Path -Path "$venvRoot\$venvName-3.7.2\python.exe" | Should -BeFalse
    }
}