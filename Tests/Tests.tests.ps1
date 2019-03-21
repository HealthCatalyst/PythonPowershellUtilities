Describe "Installing new python versions and creating virtual environments" -Tag "Unit" {
    Import-Module "$PSScriptRoot\..\PythonPowershellUtilities.psm1" -Force
    
    $testVersion = "3.7.2"
    # Make sure to test paths that have spaces
    $testPythonInstallRoot = "C:\Program Files\Python\My Install Root"
    $testVirtualEnvironmentRoot = "C:\Program Files\Python\My Python Virtual Environments"
    $defaultInstallRoot = "C:\PythonInstallations\"
    $defaultVirtualEnvironmentRoot = "C:\PythonVirtualEnvironments\"

    
    It 'Should get newly-set value' {
        Set-PythonInstallRoot -Path $testPythonInstallRoot -Force
        Get-PythonInstallRoot | Should -Be $testPythonInstallRoot

        Set-VirtualEnvironmentRoot -Path $testVirtualEnvironmentRoot -Force
        Get-VirtualEnvironmentRoot | Should -Be $testVirtualEnvironmentRoot
    }

    New-PythonInstallation -Version $testVersion
    $installRoot = Get-PythonUtilitiesConfigValue "PythonInstallRoot"
    It 'Should create a new python $testVersion installation' {
        Test-Path -Path "$installRoot\python$testVersion\python.exe" | Should -BeTrue
    }

    $venvName = "TestEnv"
    $venvRoot = Get-PythonUtilitiesConfigValue "VirtualEnvironmentRoot"
    New-PythonVirtualEnvironment -Version $testVersion -Name $venvName
    It 'Should create a new virtual environment' {
        Test-Path -Path "$venvRoot\$venvName-$testVersion\Scripts\python.exe" | Should -BeTrue
    }

    Enter-PythonVirtualEnvironment -Name $venvName
    $result = Start-Process "pip" -ArgumentList "--disable-pip-version-check install toolz" -NoNewWindow -Wait -PassThru
    It 'Should install the test dependency into the new venv' {
        Test-Path -Path "$venvRoot\$venvName-$testVersion\Lib\site-packages\toolz" | Should -BeTrue
    }

    deactivate
    It 'Should return the correct number of environments' {
        $envs = Get-PythonVirtualEnvironments
        $envs.Count | Should -Be 1
        $envs[0] | Should -Be "$venvName-$testVersion"
    }

    Remove-PythonVirtualEnvironment -Name $venvName -YesToAll
    It 'Should delete the newly-created venv' {
        Test-Path -Path "$venvRoot\$venvName-$testVersion\python.exe" | Should -BeFalse
    }

    Remove-PythonInstallation -Version $testVersion

    It "Should reset the config to the default value" {
        Restore-PythonUtilitiesConfigDefaults -Force
        Get-PythonInstallRoot | Should -Be $defaultInstallRoot
        Get-VirtualEnvironmentRoot | Should -Be $defaultVirtualEnvironmentRoot
    }
}