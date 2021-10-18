function ll
	ls -lha $argv
end

function dt
	tmux detach -a
end

alias td="dt"
