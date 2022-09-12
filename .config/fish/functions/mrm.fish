function mrm
	# 인자 argv가 없을 때 기본 실행문입니다
	# test -n 는 string length 가 non-zero인지 
	# test -z 는 zero인지를 판별하는 문구입니다
	if test -z $argv[1]
	# if not set -q argv[1]
		echo '0: writing, 1:arranging, 2:mixing'
	else
		if test $argv[1] -eq 0
			curl http://utylee.duckdns.org/midea/remove/writing/$argv[2]
		else if test $argv[1] -eq 1
			curl http://utylee.duckdns.org/midea/remove/arranging/$argv[2]
		else if test $argv[1] -eq 2
			curl http://utylee.duckdns.org/midea/remove/mixing/$argv[2]
		end
	end
end
