# CHANGE TO SCRIPT DIRECTORY
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
Push-Location $dir

# GET CONFIGS
. .\config.ps1

# CONNECT TO WSA
$device = "127.0.0.1:58526"
$connectResponse = & "${adbDir}\adb.exe" connect $device

# MAKE SURE CONNECTION WAS SUCCESSFULL
if($connectResponse -like 'already connected to *') {
	# connected
} else {
	Write-Host "Error connecting!"
	Write-Host "$connectResponse"
	Exit 1
}

# GET THE IP
$cmd = "ifconfig wlan0 | grep 'inet addr' | cut -d: -f2 | awk '{print `$1}'"
$connectResponse = & "${adbDir}\adb.exe" -s $device shell "$cmd"
Write-Output "$connectResponse"
