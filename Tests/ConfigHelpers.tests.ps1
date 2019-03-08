
Describe "Getting and Setting Config Values" -Tag "Unit" {
    . "$PSScriptRoot\..\Functions\Get-PythonUtilitiesConfigValue.ps1"
    . "$PSScriptRoot\..\Functions\Set-PythonUtilitiesConfigValue.ps1"

    It 'Should get newly-set value' {
        $testValue = "42"
        Set-PythonUtilitiesConfigValue -Key "PythonInstallRoot" -Value $testValue
        Get-PythonUtilitiesConfigValue -Key "PythonInstallRoot" | Should -Be $testValue
    }
}