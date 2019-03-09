$script:ModuleRoot = $PSScriptRoot
$script:ScriptDir = "$script:ModuleRoot\Functions"

#Taken from the DosInstallUtilities
function Import-Function{
    param(
        [string] $folderPath
    )

    $functionFiles = Get-ChildItem -Path $folderPath -Filter *.ps1

    Write-Verbose "Loading scripts in $folderPath"
    foreach($file in $functionFiles){
        Write-Verbose "Sourcing $($file.FullName)"
        . $file.FullName
    }
}

# Have to dot source the function call, otherwise the function are only loaded in the function scope (and not visible in to the module)
. Import-Function -folderPath $script:ScriptDir

Export-ModuleMember -Function Get-PythonUtilitiesConfig
Export-ModuleMember -Function New-PythonInstallation
Export-ModuleMember -Function New-PythonVirtualEnvironment
Export-ModuleMember -Function Enter-PythonVirtualEnvironment
Export-ModuleMember -Function Set-PythonUtilitesConfigValue
Export-ModuleMember -Function Get-InstalledPythonVersions
Export-ModuleMember -Function Get-PythonUtilitiesConfigValue
Export-ModuleMember -Function Set-PythonUtilitiesConfigValue