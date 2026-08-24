function vpnff 
	ssh -N -D 127.0.0.1:10808 \
        -o ExitOnForwardFailure=yes \
        -o ServerAliveInterval=30 \
        -o ServerAliveCountMax=3 \
        utylee@152.69.195.135
end
