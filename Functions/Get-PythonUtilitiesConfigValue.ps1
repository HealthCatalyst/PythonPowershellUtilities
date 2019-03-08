$script:configPath = "$PSScriptRoot\..\Config\config.json"

function Get-PythonUtilitiesConfigValue([string]$Key){
    $config = Get-Content -Path $script:configPath | ConvertFrom-Json
    return $config.$Key
}