function ll
	ls -lha $argv
end

function dt
	tmux detach -a
end

alias td="dt"
alias t1="source ~/.tmuxset-misc.fish"
alias t0="source ~/.tmuxset-blog.fish"
alias we='curl http://192.168.0.202:9010;echo -e "\n"'

alias wsl2="tmux rename-window 'wsl2';ssh -p 8824 utylee@192.168.0.204"
alias mac="tmux rename-window 'mac';ssh -p 8817 utylee@192.168.0.107"
alias od="tmux rename-window 'od';ssh -p 8821 odroid@192.168.0.201"
alias hc="tmux rename-window 'hc';ssh -p 8822 odroid@192.168.0.202"
alias hc2="tmux rename-window 'hc2';ssh -p 8823 odroid@192.168.0.203"
