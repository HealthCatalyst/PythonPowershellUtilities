function Get-PythonInstallerUrl($Version){
    # python versions 2.7.x do not have executable installers and must be installed manually
    $installerURLMap = @{
        '3.7.2' = "https://www.python.org/ftp/python/3.7.2/python-3.7.2-amd64.exe";
        '3.6.8' = "https://www.python.org/ftp/python/3.6.8/python-3.6.8-amd64.exe";
    }

    return $installerURLMap[$Version]
}

