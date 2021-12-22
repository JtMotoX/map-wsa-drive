# CHANGE TO SCRIPT DIRECTORY
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
Push-Location $dir

# CREATE OR UPDATE THE SHORTCUT
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("${dir}\Open WSA Drive.lnk")
$shortcut.TargetPath = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
$shortcut.Arguments = "-command `"& '${scriptpath}'`""
$shortcut.IconLocation = "${dir}\open-wsa-drive-icon.ico"
$Shortcut.Save()

# GET CONFIGS
. .\config.ps1

# GET THE WSA IP ADDRESS
$wsaIP = .\get-ip.ps1
if(!$?) { Exit 1; }

# DETERMINE THE SOURCE WE ARE GOING TO MAP
$mapSource = "\\${wsaIP}${wsaDir}"

# STOP IF ALREADY CONNECTED
If (Test-Path -Path "${driveLetter}:\.mapped") {
	Write-Host "Already Connected!"
	Invoke-Item "${driveLetter}:\"
	Exit 0
}

# REMOVE EXISTING MAP IF PRESENT
If (Test-Path -Path "${driveLetter}:\") {
	Write-Host "Disconnecting existing map . . ."
	net use ${driveLetter}: /delete /y
	if(!$?) { Write-Host "There was an error disconnecting existing map"; Exit 1; }
}

# CREATE THE MAP NETWORK DRIVE
Write-Host "Mapping '$mapSource' to ${driveLetter}:\ . . ."
$net = new-object -ComObject WScript.Network
$net.MapNetworkDrive("${driveLetter}:", "$mapSource", $false, "${lanDriveUser}", "${lanDrivePass}")
$rename = New-Object -ComObject Shell.Application
$rename.NameSpace("${driveLetter}:\").Self.Name = "${driveTitle} ($mapSource)"

# OPEN THE MAPPED NETWORK DRIVE
Invoke-Item "${driveLetter}:\"
