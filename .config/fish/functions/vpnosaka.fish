function vpnosaka
	ssh -vv \
      # osaka oracle for sukebei vpn
        -N \
        -D 127.0.0.1:10808 \
        -o ServerAliveInterval=30 \
        -o ServerAliveCountMax=3 \
        -o ExitOnForwardFailure=yes \
        utylee@152.69.195.135
end
