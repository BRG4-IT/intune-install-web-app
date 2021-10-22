<#
    .SYNOPSIS
        Creates shortcuts to a web app on the desktop using the default browser.
    .DESCRIPTION
        Author:  Michael Rundel/John Seerden (https://www.srdn.io)
        Version: 2.0

        Creates shortcuts to a web app, using the default browser, on the Desktop.
    .PARAMETER ShortcutName
        Display Name of the shortcut.
    .PARAMETER ShortcutUrl
        URL associated with the shortcut.
    .PARAMETER ShortcutIconUrl
        Icon associated with the shortcut.
        
    .NOTES
        This script can either run in SYSTEM (for all users) or USER (current user only) context.
    .EXAMPLE
        Install-Web-App.ps1 -ShortcutName "Wikipedia" -ShortCutUrl "https://simple.wikipedia.org/" -ShortcutIconUrl "https://raw.githubusercontent.com/BRG4-IT/intune-install-web-app/main/demo-icon/wikipedia.ico"
        Install-Web-App.ps1 -ShortcutName "Wikipedia" -ShortCutUrl "https://simple.wikipedia.org/" -ShortcutIconUrl "https://raw.githubusercontent.com/BRG4-IT/intune-install-web-app/main/demo-icon/wikipedia.ico" -Uninstall
#>
param(
    [Parameter(Mandatory = $true)]
    [string]$ShortcutName="Wikipedia",

    [Parameter(Mandatory = $true)]
    [string]$ShortcutUrl="https://simple.wikipedia.org/",

    [Parameter(Mandatory = $false)]
    [string]$ShortcutIconUrl="https://raw.githubusercontent.com/BRG4-IT/intune-install-web-app/main/demo-icon/wikipedia.ico",
    
    [Parameter(Mandatory = $false)]
    [Switch]$Uninstall = $false

)

$WScriptShell = New-Object -ComObject WScript.Shell

$PathIcon = ""
$PathLNK = ""

$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
# Check if running in SYSTEM context (Shortcut applies for all users)
if ($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    write-host "SYSTEM context"
    if ($ShortcutIconUrl) {
        $PathIcon = "$($env:ProgramData)\Icons\$ShortcutName.ico"
    }
    $PathLNK = "$([Environment]::GetFolderPath('CommonDesktopDirectory'))\$ShortcutName.lnk"
}
# Running in USER context (Shortcut only applies for the logged on user)
else {
    write-host "USER context"
    if ($ShortcutIconUrl) {
        $PathIcon = "$($env:AppData)\Icons\$ShortcutName.ico"
    }
    $PathLNK = "$([Environment]::GetFolderPath("Desktop"))\$ShortcutName.lnk"
}


if ($Uninstall) {
    write-host "uninstalling webapp"
    if ($ShortcutIconUrl) {
        if (Test-Path "$PathIcon") {
            Remove-Item "$PathIcon" -Force
        }
    }
    if (Test-Path "$PathLNK") {
        Remove-Item "$PathLNK" -Force
    }
}
else {
    write-host "installing webapp"
    if ($ShortcutIconUrl) {
        $baseDir = $PathIcon -replace "\\$ShortcutName.ico",""
        if (-not (Test-Path "$baseDir")) {
            New-Item -Path "$baseDir" -ItemType Directory
        }

        # Let's Uninstall the existing shortcut, in case we want to replace it with a newer one.
        if (Test-Path "$PathIcon") {
            Remove-Item "$PathIcon" -Force
        }

        # Download the shortcut
        try {
            (New-Object System.Net.WebClient).DownloadFile($ShortcutIconUrl, "$PathIcon")
            # (New-Object System.Net.WebClient).DownloadFile("https://www.brg4.at/tools/ico/untis.ico", "$PathIcon")
        }
        catch [Net.WebException] {
            # Write-Host $_.Exception.ToString()
            Write-Host "Icon URL invalid"
        }
    }
    $Shortcut = $WScriptShell.CreateShortcut("$PathLNK") 
    $Shortcut.TargetPath = $ShortcutUrl
    if (Test-Path "$PathIcon") {
        $Shortcut.IconLocation = "$PathIcon"
    }
    else {
        $Shortcut.IconLocation = "%SystemRoot%\system32\netshell.dll, 85"
    }
    $Shortcut.Save()
}
