function fzf-lls-model-widget -d "Pick a GGUF model for lls/llm/llh start (ssh host aware)"
    set -l commandline (__fzf_parse_commandline)
    set -l fzf_query $commandline[2]
    set -l prefix $commandline[3]

    # 커맨드라인 첫 토큰으로 대상 결정
    set -l full (string trim -- (commandline))
    set -l first (string split -m1 ' ' -- $full)[1]

    # host + 모델 디렉토리 결정 (bash if/else 안 씀)
    set -l host wsl12
    set -l rdir "/home/utylee/temp/llm_models"

    switch $first
        case llm
            set host mac
            # set rdir "$HOME/temp/llm_models"
            set rdir "/Users/utylee/temp/llm_models"
        case llm2
            set host mac2
            # set rdir "$HOME/temp/llm_models"
            set rdir "/Users/utylee/temp/llm_models"
        case llh
            set host halo
            set rdir "/home/utylee/temp/llm_models"
        case llc
            set host ccy
            set rdir "/home/utylee/temp/llm_models/"
        # case lls
        case llw
            set host wsl12
            set rdir "/home/utylee/temp/llm_models"
        # case '*'
        #     # lls/llm/llh 문맥이 아니면 조용히 종료 (기존 UX)
        #     commandline -f repaint
        #     return
    end

    # 원격 find 한 줄만 안전하게 실행 (네 기존 방식 유지)
    set -l mycommand "command ssh $host " \
        # (string escape -- "find '$rdir' -maxdepth 1 -type f -name '*.gguf' -printf '%f\n' 2>/dev/null")
		(string escape -- "find '$rdir' -maxdepth 1 -type f -name '*.gguf' -print 2>/dev/null | xargs -n1 basename 2>/dev/null")
    set mycommand (string join '' $mycommand)

    begin
        test -n "$FZF_TMUX_HEIGHT"; or set -g FZF_TMUX_HEIGHT 50%
        set -lx FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT --reverse --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS"

        set -l candidates (eval $mycommand)

		set -l full (string trim -- (commandline))
		set -l first (string split -m1 ' ' -- $full)[1]
		set -l preview_cmd "$first show-profile {}"

        set -l choice (printf '%s\n' $candidates | command fzf \
            --query "$fzf_query" \
            # --preview 'lls-profile-for-model {}' \
			# --preview 'lls show-profile {}' \
			--preview "$preview_cmd" \
            --preview-window 'right,40%,wrap')
        if test -n "$choice"
            set result $choice
        end
    end

    if test -z "$result"
        commandline -f repaint
        return
    end

    commandline -t ""
    for i in $result
        commandline -it -- $prefix
        commandline -it -- (string escape $i)
        commandline -it -- ' '
    end
    commandline -f repaint
end

# function fzf-lls-model-widget -d "Pick a GGUF model for lls/llm/llh start (ssh host aware)"
#    set -l commandline (__fzf_parse_commandline)
#     set -l fzf_query $commandline[2]
#     set -l prefix $commandline[3]

#     # 커맨드라인 첫 토큰으로 대상 결정
#     set -l full (string trim -- (commandline))
#     set -l first (string split -m1 ' ' -- $full)[1]

#     # host + 모델 디렉토리 결정 (bash if/else 안 씀)
#     set -l host wsl2
#     set -l rdir "/home/utylee/temp/llm_models"

#     switch $first
#         case llm
#             set host mac
#             set rdir "$HOME/temp/llm_models"
#         case llh
#             set host halo
#             set rdir "/home/utylee/temp/llm_models"
#         case lls
#             set host wsl2
#             set rdir "/home/utylee/temp/llm_models"
#         case '*'
#             # lls/llm/llh 문맥이 아니면 조용히 종료 (기존 UX)
#             commandline -f repaint
#             return
#     end

#     # 원격 find 한 줄만 안전하게 실행 (네 기존 방식 유지)
#     set -l mycommand "command ssh $host " \
#         (string escape -- "find '$rdir' -maxdepth 1 -type f -name '*.gguf' -printf '%f\n' 2>/dev/null")
#     set mycommand (string join '' $mycommand)

#     begin
#         test -n "$FZF_TMUX_HEIGHT"; or set -g FZF_TMUX_HEIGHT 50%
#         set -lx FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT --reverse --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS"

#         set -l candidates (eval $mycommand)

#         set -l choice (printf '%s\n' $candidates | command fzf \
#             --query "$fzf_query" \
#             --preview 'lls-profile-for-model {}' \
#             --preview-window 'right,40%,wrap')
#         if test -n "$choice"
#             set result $choice
#         end
#     end

#     if test -z "$result"
#         commandline -f repaint
#         return
#     end

#     commandline -t ""
#     for i in $result
#         commandline -it -- $prefix
#         commandline -it -- (string escape $i)
#         commandline -it -- ' '
#     end
#     commandline -f repaint
# end



# function fzf-lls-model-widget -d "Pick a GGUF model for lls/llm/llh start (ssh config aware)"
#     set -l commandline (__fzf_parse_commandline)
#     set -l fzf_query $commandline[2]
#     set -l prefix $commandline[3]

#     set -l full (string trim -- (commandline))
#     set -l first (string split -m1 ' ' -- $full)[1]

#     set -l host wsl2
#     set -l default_dir "/home/utylee/temp/llm_models"

#     switch $first
#         case llm
#             set host mac
#             set default_dir "$HOME/temp/llm_models"
#         case llh
#             set host halo
#             set default_dir "/home/utylee/temp/llm_models"
#         case lls
#             set host wsl2
#             set default_dir "/home/utylee/temp/llm_models"
#         case '*'
#             commandline -f repaint
#             return
#     end

#     # ${VAR:-default} 같은 bash 문법을 아예 쓰지 않는다 (fish가 싫어함)
#     set -l script 'if [ -n "$LLS_MODELS_DIR" ]; then dir="$LLS_MODELS_DIR"; else dir="DEFAULT_DIR"; fi; find "$dir" -maxdepth 1 -type f -name "*.gguf" -printf "%f\n" 2>/dev/null'
#     set script (string replace -a "DEFAULT_DIR" $default_dir -- $script)

#     set -l candidates (command ssh $host bash -lc "$script")

#     if test (count $candidates) -eq 0
#         commandline -f repaint
#         return
#     end

#     begin
#         test -n "$FZF_TMUX_HEIGHT"; or set -g FZF_TMUX_HEIGHT 50%
#         set -lx FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT --reverse --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS"

#         set -l choice (printf '%s\n' $candidates | command fzf \
#             --query "$fzf_query" \
#             --preview 'lls-profile-for-model {}' \
#             --preview-window 'right,40%,wrap')

#         if test -z "$choice"
#             commandline -f repaint
#             return
#         end

#         commandline -t ""
#         commandline -it -- $prefix
#         commandline -it -- (string escape $choice)
#         commandline -it -- ' '
#     end

#     commandline -f repaint
# end


# function fzf-lls-model-widget -d "Pick a GGUF model for lls/llm/llh start (ssh config aware)"
#     set -l commandline (__fzf_parse_commandline)
#     set -l fzf_query $commandline[2]
#     set -l prefix $commandline[3]

#     set -l full (string trim -- (commandline))
#     set -l first (string split -m1 ' ' -- $full)[1]

#     set -l host wsl2
#     set -l default_dir "/home/utylee/temp/llm_models"

#     switch $first
#         case llm
#             set host mac
#             set default_dir "$HOME/temp/llm_models"
#         case llh
#             set host halo
#             set default_dir "/home/utylee/temp/llm_models"
#         case lls
#             set host wsl2
#             set default_dir "/home/utylee/temp/llm_models"
#         case '*'
#             commandline -f repaint
#             return
#     end

#     # IMPORTANT:
#     # - ${LLS_MODELS_DIR:-...} 는 bash 문법이라 fish가 보면 터짐
#     # - 그래서 fish에서는 single-quote 문자열로 "그대로" 유지하고,
#     #   DEFAULT_DIR만 치환한 뒤 ssh로 넘겨서 원격 bash가 해석하게 한다.
#     set -l script 'dir="${LLS_MODELS_DIR:-DEFAULT_DIR}"; find "$dir" -maxdepth 1 -type f -name "*.gguf" -printf "%f\n" 2>/dev/null'
#     set script (string replace -a "DEFAULT_DIR" $default_dir -- $script)

#     set -l candidates (command ssh $host bash -lc "$script")

#     if test (count $candidates) -eq 0
#         commandline -f repaint
#         return
#     end

#     begin
#         test -n "$FZF_TMUX_HEIGHT"; or set -g FZF_TMUX_HEIGHT 50%
#         set -lx FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT --reverse --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS"

#         set -l choice (printf '%s\n' $candidates | command fzf \
#             --query "$fzf_query" \
#             --preview 'lls-profile-for-model {}' \
#             --preview-window 'right,40%,wrap')

#         if test -z "$choice"
#             commandline -f repaint
#             return
#         end

#         commandline -t ""
#         commandline -it -- $prefix
#         commandline -it -- (string escape $choice)
#         commandline -it -- ' '
#     end

#     commandline -f repaint
# end




#function fzf-lls-model-widget -d "Pick a GGUF model for lls/llm/llh start (ssh config aware)"
#    set -l commandline (__fzf_parse_commandline)
#    set -l dir $commandline[1]
#    set -l fzf_query $commandline[2]
#    set -l prefix $commandline[3]

#    # 현재 커맨드라인 첫 토큰으로 대상 판단 (lls/llm/llh)
#    set -l full (string trim -- (commandline))
#    set -l first (string split -m1 ' ' -- $full)[1]

#    # 기본은 wsl2로 (lls)
#    set -l host wsl2
#    set -l default_dir "/home/utylee/temp/llm_models"

#    switch $first
#        case llm
#            set host mac
#            set default_dir "$HOME/temp/llm_models"
#        case llh
#            set host halo
#            set default_dir "/home/utylee/temp/llm_models"
#        case lls
#            set host wsl2
#            set default_dir "/home/utylee/temp/llm_models"
#        case '*'
#            # lls/llm/llh 문맥이 아니면 그냥 리페인트하고 종료 (너 UX 유지)
#            commandline -f repaint
#            return
#    end

#    # 원격에서 모델 목록 출력 (basename만)
#    # - 우선: 원격 환경변수 LLS_MODELS_DIR
#    # - 없으면: host별 default_dir
#    set -l remote_cmd "if [ -n \"\$LLS_MODELS_DIR\" ]; then dir=\"\$LLS_MODELS_DIR\"; else dir=\"$default_dir\"; fi; find \"\$dir\" -maxdepth 1 -type f -name '*.gguf' -printf '%f\n' 2>/dev/null"

#    set -l candidates (command ssh $host $remote_cmd)

#    if test (count $candidates) -eq 0
#        commandline -f repaint
#        return
#    end

#    begin
#        test -n "$FZF_TMUX_HEIGHT"; or set -g FZF_TMUX_HEIGHT 50%
#        set -lx FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT --reverse --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS"

#        set -l choice (printf '%s\n' $candidates | command fzf \
#            --query "$fzf_query" \
#            --preview 'lls-profile-for-model {}' \
#            --preview-window 'right,40%,wrap')

#        if test -z "$choice"
#            commandline -f repaint
#            return
#        end

#        # 마지막 토큰 지우고(너 기존 UX 유지) 선택값 삽입
#        commandline -t ""
#        commandline -it -- $prefix
#        commandline -it -- (string escape $choice)
#        commandline -it -- ' '
#    end

#    commandline -f repaint
#end



##function fzf-lls-model-widget -d "Pick a GGUF model for 'lls start' (remote WSL2 aware)"
##    set -l commandline (__fzf_parse_commandline)
##    set -l dir $commandline[1]
##    set -l fzf_query $commandline[2]
##    set -l prefix $commandline[3]

##    # # 지금 커맨드라인이 'lls start' 문맥인지 체크
##    # set -l full (commandline)
##    # if not string match -rq '(^|\s)lls\s+start(\s|$)' -- $full
##    #     commandline -f repaint
##    #     return
##    # end

##    # 모델 목록 커맨드 구성 (remote / local)
##    set -l mycommand

##    if test "$LLS_REMOTE" = "1"
##        set -l rdir $LLS_REMOTE_MODELS_DIR
##        if test -z "$rdir"
##            set rdir "/home/utylee/temp/llm_models"
##        end

##        # WSL2에서 파일명만 출력
##        # -printf '%f\n' : basename만
##        # set mycommand "command ssh -p 8812 utylee@localhost " \
##        set mycommand "command ssh wsl12 " \
##            (string escape -- "find '$rdir' -maxdepth 1 -type f -name '*.gguf' -printf '%f\n' 2>/dev/null")
##        set mycommand (string join '' $mycommand)
##    else
##        # set -l mdir $LLS_MODELS_DIR
##        set -l mdir $LLS_REMOTE_MODELS_DIR
##        if test -z "$mdir"
##            set mdir "$HOME/llm_models"
##        end
##        set mycommand "command find -L " (string escape -- $mdir) " -maxdepth 1 -type f -name '*.gguf' -printf '%f\n' 2>/dev/null"
##        set mycommand (string join '' $mycommand)
##    end

##	##fzf UI 옵션: 네 위젯 스타일 그대로
##    # test -n "$FZF_TMUX_HEIGHT"; or set -g FZF_TMUX_HEIGHT 50%

##	# begin
##	# 	set -lx FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT --reverse --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS"

##	# 	set -l fzf_opts "--query "(string escape -- $fzf_query)" --preview "(string escape -- $preview_cmd)" --preview-window=right:60%:wrap"

##	# 	set -l cmd "$mycommand | "(__fzfcmd)" $fzf_opts | while read -l r; set result \$result \$r; end"
##	# 	eval $cmd
##	# end

##	begin
##		# tmux 높이 기본값
##		test -n "$FZF_TMUX_HEIGHT"; or set -g FZF_TMUX_HEIGHT 50%

##		# (중요) preview 관련 옵션이 먹도록, 여기서는 __fzfcmd 대신 fzf 직접 호출
##		set -lx FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT --reverse --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS"

##		set -l candidates (eval $mycommand)

##		set -l choice (printf '%s\n' $candidates | command fzf \
##			--query "$fzf_query" \
##			--preview 'lls-profile-for-model {}' \
##			--preview-window 'right,40%,wrap')
##		if test -n "$choice"
##			set result $choice
##		end
##	end


##    if test -z "$result"
##        commandline -f repaint
##        return
##    end

##    # 마지막 토큰 지우고 (파일 위젯과 동일한 UX)
##    commandline -t ""

##    # 단일 선택이지만 result 배열 형태로 들어오므로 동일한 루프 사용
##    for i in $result
##        # prefix(예: 경로 앞에 붙일 문자) 쓰고 싶으면 유지
##        # 모델명은 공백이 없겠지만 escape는 안전하게
##        commandline -it -- $prefix
##        commandline -it -- (string escape $i)
##        commandline -it -- ' '
##    end

##    commandline -f repaint
##end
