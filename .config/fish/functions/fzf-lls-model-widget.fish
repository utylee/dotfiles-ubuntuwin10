#<<<<<<< HEAD
#function fzf-lls-model-widget -d "Pick a GGUF model for 'lls start' (remote WSL2 aware)"
#    set -l commandline (__fzf_parse_commandline)
#    set -l dir $commandline[1]
#    set -l fzf_query $commandline[2]
#    set -l prefix $commandline[3]

#    # # 지금 커맨드라인이 'lls start' 문맥인지 체크
#    # set -l full (commandline)
#    # if not string match -rq '(^|\s)lls\s+start(\s|$)' -- $full
#    #     commandline -f repaint
#    #     return
#    # end

#    # 모델 목록 커맨드 구성 (remote / local)
#    set -l mycommand

#    if test "$LLS_REMOTE" = "1"
#        set -l rdir $LLS_REMOTE_MODELS_DIR
#        if test -z "$rdir"
#            set rdir "/home/utylee/temp/llm_models"
#        end

#        # WSL2에서 파일명만 출력
#        # -printf '%f\n' : basename만
#        # set mycommand "command ssh -p 8812 utylee@localhost " \
#        set mycommand "command ssh wsl12 " \
#            (string escape -- "find '$rdir' -maxdepth 1 -type f -name '*.gguf' -printf '%f\n' 2>/dev/null")
#        set mycommand (string join '' $mycommand)
#    else
#        # set -l mdir $LLS_MODELS_DIR
#        set -l mdir $LLS_REMOTE_MODELS_DIR
#        if test -z "$mdir"
#            set mdir "$HOME/llm_models"
#        end
#        set mycommand "command find -L " (string escape -- $mdir) " -maxdepth 1 -type f -name '*.gguf' -printf '%f\n' 2>/dev/null"
#        set mycommand (string join '' $mycommand)
#    end

#	##fzf UI 옵션: 네 위젯 스타일 그대로
#    # test -n "$FZF_TMUX_HEIGHT"; or set -g FZF_TMUX_HEIGHT 50%

#	# begin
#	# 	set -lx FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT --reverse --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS"

#	# 	set -l fzf_opts "--query "(string escape -- $fzf_query)" --preview "(string escape -- $preview_cmd)" --preview-window=right:60%:wrap"

#	# 	set -l cmd "$mycommand | "(__fzfcmd)" $fzf_opts | while read -l r; set result \$result \$r; end"
#	# 	eval $cmd
#	# end

#	begin
#		# tmux 높이 기본값
#		test -n "$FZF_TMUX_HEIGHT"; or set -g FZF_TMUX_HEIGHT 50%

#		# (중요) preview 관련 옵션이 먹도록, 여기서는 __fzfcmd 대신 fzf 직접 호출
#		set -lx FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT --reverse --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS"

#		set -l candidates (eval $mycommand)

#		set -l choice (printf '%s\n' $candidates | command fzf \
#			--query "$fzf_query" \
#			--preview 'lls-profile-for-model {}' \
#			--preview-window 'right,40%,wrap')
#		if test -n "$choice"
#			set result $choice
#		end
#	end

#=======
function fzf-lls-model-widget -d "Pick GGUF model (local/ssh aware, NO eval)"
    set -l commandline (__fzf_parse_commandline)
    set -l fzf_query $commandline[2]
    set -l prefix $commandline[3]

    set -l full (string trim -- (commandline))
    set -l first (string split -m1 ' ' -- $full)[1]

    # 기본값
    set -l host local
    set -l rdir "/home/utylee/temp/llm_models"

    if test (uname) = Darwin
        set rdir "/Users/utylee/temp/llm_models"
    end

    if set -q LLS_MODELS_DIR
        set rdir "$LLS_MODELS_DIR"
    end

    switch $first
        case llm
            set host mac
            set rdir "/Users/utylee/temp/llm_models"
            if set -q LLS_MODELS_DIR
                set rdir "$LLS_MODELS_DIR"
            end

        case llh
            set host halo
            if set -q LLS_MODELS_DIR
                set rdir "$LLS_MODELS_DIR"
            end

        case llw
            set host wsl12
            if set -q LLS_MODELS_DIR
                set rdir "$LLS_MODELS_DIR"
            end

		case '*'
			# ✅ 알 수 없는 커맨드/빈 라인에서도 lls 기준으로 동작하게 강제
			set host local
			set first lls
			# set prefix "lls start "

			# 선택한 모델(예: phi-4-IQ4_NL.gguf)
			set -l m "$selected"

			# 현재 커맨드라인 전체
			set -l cl (commandline)

			# 이미 lls start로 시작하면 모델만 교체/삽입
			if string match -qr '^\s*lls\s+start(\s|$)' -- $cl
				# "lls start <기존모델.gguf>" 형태면 모델만 교체
				set -l newcl (string replace -r '(^\s*lls\s+start\s+)(\S+\.gguf)?' "\$1$m" -- $cl)

				if test "$newcl" = "$cl"
					# 모델 토큰이 없던 경우: 뒤에 추가
					commandline --append " $m"
				else
					commandline --replace "$newcl"
				end
			else
				# 새로 시작하는 경우
				commandline --replace "lls start $m"
			end

			# 커서 맨 끝
			commandline --cursor (string length (commandline))
    end

    # ✅ candidates 생성 (핵심 안정 영역 🔥)
    set -l candidates

    if test "$host" = local
        set candidates (find "$rdir" -maxdepth 1 -type f -name "*.gguf" -print 2>/dev/null | \
            while read -l p
                basename "$p"
            end)
    else
        set candidates (command ssh $host find "$rdir" -maxdepth 1 -type f -name "*.gguf" -print 2>/dev/null | \
            while read -l p
                basename "$p"
            end)
    end

    if test (count $candidates) -eq 0
        echo "NO MODELS FOUND: $rdir"
        commandline -f repaint
        return
    end

    set -l preview_cmd "$first show-profile {}"

    begin
        test -n "$FZF_TMUX_HEIGHT"; or set -g FZF_TMUX_HEIGHT 50%
        set -lx FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT --reverse"

        set -l choice (printf '%s\n' $candidates | command fzf \
            --query "$fzf_query" \
            --preview "$preview_cmd" \
            --preview-window 'right,40%,wrap')

        if test -n "$choice"
            set result $choice
        end
    end
# >>>>>>> 1df2ea1177ab26ab5a14f2d4a219fbd2af3adb33

    if test -z "$result"
        commandline -f repaint
        return
    end

# <<<<<<< HEAD
#     # 마지막 토큰 지우고 (파일 위젯과 동일한 UX)
#     commandline -t ""

#     # 단일 선택이지만 result 배열 형태로 들어오므로 동일한 루프 사용
#     for i in $result
#         # prefix(예: 경로 앞에 붙일 문자) 쓰고 싶으면 유지
#         # 모델명은 공백이 없겠지만 escape는 안전하게
#         commandline -it -- $prefix
#         commandline -it -- (string escape $i)
#         commandline -it -- ' '
#     end

# =======
    commandline -t ""
    commandline -it -- $prefix
    commandline -it -- (string escape $result)
    commandline -it -- ' '
# >>>>>>> 1df2ea1177ab26ab5a14f2d4a219fbd2af3adb33
    commandline -f repaint
end
