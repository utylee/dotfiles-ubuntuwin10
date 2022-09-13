function madd
	# 인자 argv가 없을 때 기본 실행문입니다
	# test -n 는 string length 가 non-zero인지 
	# test -z 는 zero인지를 판별하는 문구입니다
	if test -z $argv[1]
	# if not set -q argv[1]
		echo '0: writing, 1: sounding, 2:arranging, 3:mixing'
	else
		set b $argv[2]
		set b (string replace -a '?' '_u_qa_' "$b")
		set b (string replace -a '&' '_u_im_' "$b")
		set b (string replace -a ' ' '_u_sp_' "$b")

		if test $argv[1] -eq 0
		    echo http://193.168.1.202:9007/add/writing/"$b"
		    curl http://192.168.1.202:9007/add/writing/"$b"
		    # curl http://192.168.1.202:9007/add/writing/$argv[2]
			# curl http://utylee.duckdns.org/midea/add/writing/$argv[2]
		else if test $argv[1] -eq 1
		    echo http://193.168.1.202:9007/add/sounding/"$b"
		    curl http://192.168.1.202:9007/add/sounding/"$b"
		else if test $argv[1] -eq 2
		    echo http://193.168.1.202:9007/add/arranging/"$b"
		    curl http://192.168.1.202:9007/add/arranging/"$b"
		    # curl http://192.168.1.202:9007/add/arranging/$argv[2]
			# curl http://utylee.duckdns.org/midea/add/arranging/$argv[2]
		else if test $argv[1] -eq 3
		    echo http://193.168.1.202:9007/add/mixing/"$b"
		    curl http://192.168.1.202:9007/add/mixing/"$b"
		    # curl http://192.168.1.202:9007/add/mixing/$argv[2]
			# curl http://utylee.duckdns.org/midea/add/mixing/$argv[2]
		end
	end
end
