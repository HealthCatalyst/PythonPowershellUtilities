
Describe "Getting and Setting Config Values" -Tag "Unit" {
    . "$PSScriptRoot\..\Functions\Get-PythonUtilitiesConfigValue.ps1"
    . "$PSScriptRoot\..\Functions\Set-PythonUtilitiesConfigValue.ps1"

    
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