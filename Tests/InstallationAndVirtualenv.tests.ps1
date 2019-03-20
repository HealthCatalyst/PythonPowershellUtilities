Describe "Installing new python versions and creating virtual environments" -Tag "Unit" {
    Import-Module "$PSScriptRoot\..\PythonPowershellUtilities.psm1" -Force
    
    New-PythonInstallation -Version 3.7.2
    $installRoot = Get-PythonUtilitiesConfigValue "PythonInstallRoot"
    It 'Should create a new python 3.7.2 installation' {
        Test-Path -Path "$installRoot\python3.7.2\python.exe" | Should -BeTrue
    }

    $venvName = "TestEnv"
    $venvRoot = Get-PythonUtilitiesConfigValue "VirtualEnvironmentRoot"
    New-PythonVirtualEnvironment -Version 3.7.2 -Name $venvName
    It 'Should create a new virtual environment' {
        Test-Path -Path "$venvRoot\$venvName-3.7.2\Scripts\python.exe" | Should -BeTrue
    }

    Enter-PythonVirtualEnvironment -Name $venvName
    # pip --disable-pip-version-check install toolz 
    $result = Start-Process "pip" -ArgumentList "--disable-pip-version-check install toolz" -NoNewWindow -Wait -PassThru
    It 'Should install the test dependency into the new venv' {
        Test-Path -Path "$venvRoot\$venvName-3.7.2\Lib\site-packages\toolz" | Should -BeTrue
    }

    deactivate
    It 'Should not throw an error when listing the environments' {
        $envs = Get-PythonVirtualEnvironments
        $envs.Count | Should -Be 1
        Write-Host $envs
    }

    Remove-PythonVirtualEnvironment -Name $venvName -YesToAll
    It 'Should delete the newly-created venv' {
        Test-Path -Path "$venvRoot\$venvName-3.7.2\python.exe" | Should -BeFalse
    }

    Remove-PythonInstallation -Version 3.7.2
}