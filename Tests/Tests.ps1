Describe "Installing new python versions and creating virtual environments" -Tag "Unit" {
    Import-Module "$PSScriptRoot\..\PythonPowershellUtilities.psm1" -Force
    
    $initial37Version = "3.7.2"
    $updated37Version = "3.7.3"
    $initial36Version = "3.6.5"
    $updated36Version = "3.6.8"

    # Make sure to test paths that have spaces
    $testPythonInstallRoot = "C:\Program Files\Python\My Install Root"
    $testVirtualEnvironmentRoot = "C:\Program Files\Python\My Python Virtual Environments"
    $defaultInstallRoot = "C:\PythonInstallations"
    $defaultVirtualEnvironmentRoot = "C:\PythonVirtualEnvironments"

    if ($env:Locations -eq "custom"){
        It 'Should get newly-set values' {
            Set-PythonInstallRoot -Path $testPythonInstallRoot -Force
            Get-PythonInstallRoot | Should -Be $testPythonInstallRoot

            Set-VirtualEnvironmentRoot -Path $testVirtualEnvironmentRoot -Force
            Get-VirtualEnvironmentRoot | Should -Be $testVirtualEnvironmentRoot
        }
    }
    else {
        It 'Should get default values' {
            Get-PythonInstallRoot | Should -Be $defaultInstallRoot
            Get-VirtualEnvironmentRoot | Should -Be $defaultVirtualEnvironmentRoot
        }
    }

    Install-Python -FullVersion $initial37Version
    $installRoot = Get-PythonUtilitiesConfigValue "PythonInstallRoot"
    It 'Should create a new python $initial37Version installation' {
        Test-Path -Path "$installRoot\python3.7\python.exe" | Should -BeTrue
    }

    Install-Python -FullVersion $initial36Version
    $installRoot = Get-PythonUtilitiesConfigValue "PythonInstallRoot"
    It 'Should create a new python $initial36Version installation' {
        Test-Path -Path "$installRoot\python3.6\python.exe" | Should -BeTrue
    }

    $venvName37 = "TestEnv37"
    $venvRoot = Get-PythonUtilitiesConfigValue "VirtualEnvironmentRoot"
    New-PythonVirtualEnvironment -ShortVersion 3.7 -Name $venvName37
    It 'Should create a new virtual environment' {
        Test-Path -Path "$venvRoot\$venvName37-3.7\Scripts\python.exe" | Should -BeTrue
    }

    $venvName36 = "TestEnv36"
    $venvRoot = Get-PythonUtilitiesConfigValue "VirtualEnvironmentRoot"
    New-PythonVirtualEnvironment -ShortVersion 3.6 -Name $venvName36
    It 'Should create a new virtual environment' {
        Test-Path -Path "$venvRoot\$venvName36-3.6\Scripts\python.exe" | Should -BeTrue
    }

    It 'Should throw an error when trying to create a new environment with an existing name.' {
        {New-PythonVirtualEnvironment -ShortVersion 3.6 -Name $venvName36} | Should -Throw "A virtual environment with this name and python version already exists. Please use 'Get-PythonVirtualEnvironments' to see a list of existing environments."
    }

    Enter-PythonVirtualEnvironment -Name $venvName37
    $result = Start-Process "pip" -ArgumentList "--disable-pip-version-check install toolz" -NoNewWindow -Wait -PassThru
    It 'Should install the test dependency into the new venv' {
        Test-Path -Path "$venvRoot\$venvName37-3.7\Lib\site-packages\toolz*" | Should -BeTrue
    }

    Enter-PythonVirtualEnvironment -Name $venvName36
    $result = Start-Process "pip" -ArgumentList "--disable-pip-version-check install toolz" -NoNewWindow -Wait -PassThru
    It 'Should install the test dependency into the new venv' {
        Test-Path -Path "$venvRoot\$venvName36-3.6\Lib\site-packages\toolz*" | Should -BeTrue
    }

    deactivate
    It 'Should return the correct number of environments' {
        $envs = Get-PythonVirtualEnvironments
        $envs.Count | Should -Be 2
        $envs[0] | Should -Be "$venvName36-3.6"
    }

    Update-Python -ShortVersion 3.7 -NewFullVersion $updated37Version
    It 'Venv should point to new installation' {
        Enter-PythonVirtualEnvironment -Name $venvName37
        $version = Invoke-Expression "& python --version"
        $version | Should -Be "Python $updated37Version"
        deactivate
    }

    Update-Python -ShortVersion 3.6 -NewFullVersion $updated36Version
    It 'Venv should point to new installation' {
        Enter-PythonVirtualEnvironment -Name $venvName36
        $version = Invoke-Expression "& python --version"
        $version | Should -Be "Python $updated36Version"
        deactivate
    }

    Remove-PythonVirtualEnvironment -Name $venvName37 -YesToAll
    It 'Should delete the newly-created venv' {
        Test-Path -Path "$venvRoot\$venvName-3.7\python.exe" | Should -BeFalse
    }

    Remove-PythonVirtualEnvironment -Name $venvName36 -YesToAll
    It 'Should delete the newly-created venv' {
        Test-Path -Path "$venvRoot\$venvName-3.6\python.exe" | Should -BeFalse
    }

    # use short and long version for uninstall
    Uninstall-Python -Version 3.7
    Uninstall-Python -Version $updated36Version

    if ($env:Locations -eq "custom"){
        It "Should reset the config to the default value" {
            Restore-PythonUtilitiesConfigDefaults -Force
            Get-PythonInstallRoot | Should -Be $defaultInstallRoot
            Get-VirtualEnvironmentRoot | Should -Be $defaultVirtualEnvironmentRoot
        }
    }
}