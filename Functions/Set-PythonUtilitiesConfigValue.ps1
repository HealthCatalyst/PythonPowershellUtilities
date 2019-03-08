$script:configPath = "$PSScriptRoot\..\Config\config.json"

function Set-PythonUtilitiesConfigValue([string]$Key, [string]$Value){
    $config = Get-Content -Path $script:configPath | ConvertFrom-Json
    $config.$Key = $Value
    $config | ConvertTo-Json | Out-File -FilePath $script:configPath
}