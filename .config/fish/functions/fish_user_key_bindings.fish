function fish_user_key_bindings
	fzf_key_bindings
	bind \ct fzf-file-widget		# 원래대로 파일명을 검색하는 명령어입니다
	bind \cg fzf-cd-widget			# 아래 f 와 연동하여 g로 지정했지만 alt-c 의 단축키를 변경한 거
	bind \cf fzf_directory_widget	# 'f'ull 의 의미로 씁니다. $HOME부터의 절대경로를 표시합니다
	bind \cw fzf_project_widget		# 'w'orkspace 에서 w를 쓰기로 합니다
	bind \cs 'rg . --pretty | fzf'  # 파일내부를 검색하는 명령입니다 

    # vi 입력모드에서의 동작을 위해 넣어줍니다
    if bind -M insert > /dev/null 2>&1
		bind -M insert \ct fzf-file-widget
		bind -M insert \cg fzf-cd-widget			# 
		bind -M insert \cf fzf_directory_widget
		bind -M insert \cw fzf_project_widget
		bind -M insert \cs 'rg . --pretty | fzf'
    end
end
