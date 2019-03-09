function Get-PythonInstallerUrl($Version){
    # python versions 2.7.x do not have executable installers and must be installed manually
    return "https://www.python.org/ftp/python/$Version/python-$Version-amd64.exe"
}

