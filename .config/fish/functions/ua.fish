function ua
	set b $argv
	set b (string replace '?' '_u_qa_' "$b")
	set b (string replace '&' '_u_im_' "$b")
	set b (string replace ' ' '_u_sp_' "$b")
	#echo $b
	# curl http://192.168.1.205:9205/c/"$b"
	curl http://192.168.1.203/memo/api/add/"$b"
end
