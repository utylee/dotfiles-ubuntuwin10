function vpnoff
	#cd ~/utylee/goodbyedpi-0.2.2/x86_64/
	#gsudo.exe "goodbyedpi.exe -5"
	/mnt/c/Program\ Files/OpenVPN/bin/openvpn-gui.exe --command disconnect utylee.ovpn 
end
