function vpn-osaka
	ssh -vv \
      # osaka oracle for sukebei vpn
        -N \
        -D 127.0.0.1:10808 \
        -o ExitOnForwardFailure=yes \
        utylee@152.69.195.135

end
