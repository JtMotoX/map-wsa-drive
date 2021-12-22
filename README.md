# map-wsa-drive
## Create a mapped network drive to Windows Subsystem Android

---

1. Download the android [platform-tools](https://dl.google.com/android/repository/platform-tools-latest-windows.zip)
1. Modify the Windows Subsystem for Android Settings to run "Continuous"
1. Install the "LAN drive - SAMBA Server & Client" in your Android instance
1. Configure a User/Password in Lan Drive with all Read/Write permissions
1. Copy the [config.sample.ps1](./config.sample.ps1) file to [config.ps1](./config.ps1)
1. Make the necessary changes to your [config.ps1](./config.ps1)
1. Launch powershell and execute the [map-network-drive.ps1](./map-network-drive.ps1) script which will create a shortcut "Open WSA Drive" that you can pin to your start menu or taskbar

---
Note: Lan Drive must be running in the background for this to work.