function mll
	if test -z $argv[1]
		curl http://192.168.1.202:9007/list_all
		# curl http://utylee.duckdns.org/midea/list_all
	else
		curl http://192.168.1.202:9007/list_all/$argv[1]
		# curl http://utylee.duckdns.org/midea/list_all/$argv[1]
	end
end
