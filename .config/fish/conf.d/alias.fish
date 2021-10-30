if status is-interactive
	function ll
		ls -lha $argv
	end

	function dt
		tmux detach -a
	end

	function ts
		tmux send-keys -t 1 "$argv" Enter
	end

	function vi0
		set filename $PWD/$argv[1]
		tmux send-keys -t vBLOG.0 ":e $filename" C-m
		tmux select-window -t vBLOG
		tmux select-pane -t vBLOG.0
	end

	function vi1
		set filename $PWD/$argv[1]
		tmux send-keys -t vMISC.0 ":e $filename" C-m
		tmux select-window -t vMISC
		tmux select-pane -t vMISC.0
	end

	function uc
		set b $argv
		set b (string replace '?' '_u_qa_' "$b")
		set b (string replace '&' '_u_im_' "$b")
		set b (string replace ' ' '_u_sp_' "$b")
		#echo $b
		curl http://192.168.0.202:9202/c/"$b"
	end

	alias ua=uc

	function ur
		curl http://192.168.0.202:9202/r
	end

	function uv
		curl http://192.168.0.202:9202/vt
	end

	function bye
		cd ~/utylee/goodbyedpi-0.1.5/x86_64/
		./goodbyedpi.exe -1
	end

	function cdg
		set -l toplevel (git rev-parse --show-toplevel)
		#if ! test -z toplevel
		if test $status -eq 0
			cd $toplevel
		end
	end

	alias g='git'
	alias td="dt"
	alias t1="source ~/.tmuxset-misc.fish"
	alias t0="source ~/.tmuxset-blog.fish"
	alias we='curl http://192.168.0.202:9010;echo -e "\n"'

	alias wsl="tmux rename-window 'wsl';ssh -p 8812 utylee@192.168.0.102"
	alias wsl2="tmux rename-window 'wsl2';ssh -p 8824 utylee@192.168.0.204"
	alias od="tmux rename-window 'od';ssh -p 8821 odroid@192.168.0.201"
	alias hc="tmux rename-window 'hc';ssh -p 8822 odroid@192.168.0.202"
	alias hc2="tmux rename-window 'hc2';ssh -p 8823 odroid@192.168.0.203"
	alias mac="tmux rename-window 'mac';ssh -p 8817 utylee@192.168.0.107"
end
