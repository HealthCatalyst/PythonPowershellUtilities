
function Convert-FullVersionToShortVersion([string]$FullVersion) {
$Null = @(
    $parts = $FullVersion.split('.')
    $short = [String]::Join('.', @($parts[0], $parts[1]))
)
    return $short
}

function Convert-ShortVersionToFullVersion([string]$ShortVersion) {
$Null = @(
    $fullVersion = $false
    $installedVersions = Get-InstalledPythonVersions
    foreach ($version in $installedVersions) {
        if ($version.startsWith($ShortVersion)){
            $fullVersion = $version 
        }
    }
)
    return $fullVersion
}


function Test-FullVersionIsInstalled([string]$FullVersion){
$Null = @(
    $installed = $false
    foreach ($version in $(Get-InstalledPythonVersions)){
        if ($version -eq $FullVersion){
            $installed = $true
        }
    }
)
    return $installed
}
    
    
function Test-ShortVersionIsInstalled([string]$ShortVersion){
$Null = @(
    $installed = $false
    foreach ($installedVersion in $(Get-InstalledPythonVersions)){
        $installedVersion = Convert-FullVersionToShortVersion $installedVersion
        if ($installedVersion -eq $ShortVersion){
            $installed = $true
        }
    }
)
    return $installed
}