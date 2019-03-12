
Describe "Getting and Setting Config Values" -Tag "Unit" {
    Import-Module "$PSScriptRoot\..\PythonPowershellUtilities.psm1" -Force

    
    $testValue = "42"
    It 'Should get newly-set value' {
        Set-PythonUtilitiesConfigValue -Key "PythonInstallRoot" -Value $testValue
        Get-PythonUtilitiesConfigValue -Key "PythonInstallRoot" | Should -Be $testValue
    }

    $default = "C:\PythonInstallations\"
    It "Should reset the config to the default value" {
        Restore-PythonUtilitiesConfigDefaults
        Get-PythonUtilitiesConfigValue -Key "PythonInstallRoot" | Should -Be $default
    }
}