
Describe "Getting and Setting Config Values" -Tag "Unit" {
    Import-Module "$PSScriptRoot\..\PythonPowershellUtilities.psm1" -Force

    
    $testPythonInstallValue = "42"
    $testVirtualEnvironmentValue = "37"
    It 'Should get newly-set value' {
        Set-PythonInstallRoot -Path $testPythonInstallValue -Force
        Get-PythonInstallRoot | Should -Be $testPythonInstallValue

        Set-VirtualEnvironmentRoot -Path $testVirtualEnvironmentValue -Force
        Get-VirtualEnvironmentRoot | Should -Be testVirtualEnvironmentValue
    }

    $defaultInstallRoot = "C:\PythonInstallations\"
    $defaultVirtualEnvironmentRoot = "C:\PythonVirtualEnvironments\"
    It "Should reset the config to the default value" {
        Restore-PythonUtilitiesConfigDefaults
        Get-PythonInstallRoot | Should -Be $defaultInstallRoot
        Get-VirtualEnvironmentRoot | Should -Be $defaultVirtualEnvironmentRoot
    }
}