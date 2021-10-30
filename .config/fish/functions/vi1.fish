function vi1
	set filename $PWD/$argv[1]
	tmux send-keys -t vMISC.0 ":e $filename" C-m
	tmux select-window -t vMISC
	tmux select-pane -t vMISC.0
end
