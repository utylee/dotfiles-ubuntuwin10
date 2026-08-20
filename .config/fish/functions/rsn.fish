function rsn
	rsync -ah -I --no-p --no-g --no-o --info=progress2 $argv
end
