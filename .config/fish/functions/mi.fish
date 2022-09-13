function mi
	# 인자 argv가 없을 때 기본 실행문입니다
	# test -n 는 string length 가 non-zero인지 
	# test -z 는 zero인지를 판별하는 문구입니다
	if test -z $argv[1]
	# if not set -q argv[1]
		# curl http://utylee.duckdns.org/midea/pick/any
		curl http://192.168.1.202:9007/pick/any
	else
		if test $argv[1] -eq 0
		    curl http://192.168.1.202:9007/pick/writing
			# curl http://utylee.duckdns.org/midea/pick/writing
		else if test $argv[1] -eq 1
		    curl http://192.168.1.202:9007/pick/sounding
			# curl http://utylee.duckdns.org/midea/pick/sounding
		else if test $argv[1] -eq 2
		    curl http://192.168.1.202:9007/pick/arranging
			# curl http://utylee.duckdns.org/midea/pick/arranging
		else if test $argv[1] -eq 3
		    curl http://192.168.1.202:9007/pick/mixing
			# curl http://utylee.duckdns.org/midea/pick/mixing
		end
	end
end
