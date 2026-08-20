function vi0
	set filename $PWD/$argv[1]
	tmux send-keys -t vBLOG.0 ":e $filename" C-m
	tmux select-window -t vBLOG
	tmux select-pane -t vBLOG.0
end
