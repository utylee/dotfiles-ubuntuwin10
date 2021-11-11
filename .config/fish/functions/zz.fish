# z에 fzf fuzzy 기능을 가능하게 하는 래핑한 함수힙니다
function zz
	# 인자가 있어서 함수를 실행합니다 
	if ! test -z $argv
		#cd (__z -l | fzf --filter=$argv | sed -n '1p' | string replace -a -r '[\d]*\s*/' '/')
		set -l dir (__z -l | fzf --filter=$argv | sed -n '1p' | string replace -a -r '\d*[\.\d*]*\s*/' '/')

		# 검색 결과가 있어야 실행합니다
		if ! test -z $dir
			cd $dir
		end
	end
end
