# Creating Desktop Shortcuts with intune (User & System context)

`install-web-app` lets you depoly desktop shortcuts to machines and users in your organisation. You can use the precompiled [install-web-app.intunewin](./install-web-app.intunewin?raw=true) or create your own from the powerscript script file (see below). 

The `-ShortcutIconUrl` parameter can be omitted. In this case an generic windows icon will be used. When using this parameter make sure the URL points to a valid Windows [ICO (file format)](https://en.wikipedia.org/wiki/ICO_(file_format)) file.


## Example: Create a Desktop shortcut to Wikipedia

Follow these instructions to create a desktop shortcut to [Simple Wikipedia](https://simple.wikipedia.org/) using Intune for all users in system context.


App-Typ auswählen: __Windows-App (Win32)__

Upload: [install-web-app.intunewin](./install-web-app.intunewin?raw=true)


### App-Informationen (App Information):

Name:

```
Simple Wikipedia Desktop Shortcut (AllUsers)
```

Beschreibung/Descripton

```
Create a desktop shortcut for Simple Wikipedia (https://simple.wikipedia.org/) for all users
```

Herausgeber/Publisher:

```
Wikipedia Fondation
```

### Programm 

Installationsbefehl

```
PowerShell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File "Install-Web-App.ps1" -ShortcutName "Wikipedia" -ShortCutUrl "https://simple.wikipedia.org/" -ShortcutIconUrl "https://raw.githubusercontent.com/BRG4-IT/intune-install-web-app/main/demo-icon/wikipedia.ico"
```

Deinstallationsbefehl

```
PowerShell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File "Install-Web-App.ps1" -ShortcutName "Wikipedia" -ShortCutUrl "https://simple.wikipedia.org/" -ShortcutIconUrl "https://raw.githubusercontent.com/BRG4-IT/intune-install-web-app/main/demo-icon/wikipedia.ico" -Uninstall
```

Installationsverhalten/Context: __System__


### Erkennungsregeln (Detection ruls):

Regelformat (Rule type): __Erkennungsregeln manuell konfigurieren__

Rule type/Regel Typ: File/Datei

Path/Pfad:

```
%public%\Desktop\
```

File or Folder/Datei oder Ordner: 

```
Wikipedia.lnk
```

Detection method: __File or folder exists__


## Compile script to .intunewin

If you do not want to use the precompiled [install-web-app.intunewin](./install-web-app.intunewin?raw=true) file, here is how to create it on your own:

1. Clone/download this repository
2. Download the [IntuneWinAppUtil](https://github.com/Microsoft/Microsoft-Win32-Content-Prep-Tool) Programm
3. Move `IntuneWinAppUtil.exe` to the root of this repository
4. Open a command prompt or a Powershell console
5. Navigate to the root of this repository
6. Execute the following commands:

```
.\IntuneWinAppUtil.exe -c .\ -s install-web-app.ps1 -o .\
```

## Testing the script in system context on local computer

[Download and install PsTools (3.5 MB)](https://docs.microsoft.com/en-us/sysinternals/downloads/psexec) by Mark Russinovich and use the command `psexec.exe` to open a Powershell ISE in system context.

```
psexec.exe -s -i powershell_ise.exe
```




