function wifi 
	powershell.exe -NoProfile -Command "Restart-NetAdapter -Name 'Wi-Fi 2' -Confirm:\$false"
	sleep 10
	netsh.exe wlan connect name="AX3001_5G" interface="Wi-Fi 2"
end
