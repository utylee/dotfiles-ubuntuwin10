function mll
	if test -z $argv[1]
		curl http://utylee.duckdns.org/midea/list_all
	else
		curl http://utylee.duckdns.org/midea/list_all/$argv[1]
	end
end
