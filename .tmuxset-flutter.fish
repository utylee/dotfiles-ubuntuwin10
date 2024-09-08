function divide_Flutter
	# 수평분할을 25%로 합니다 
	tmux split-window -d -t Flutter -v -p 25  #"workon misc"

	tmux select-window -t Flutter

	sleep 0.5
	tmux send-keys -t Flutter.0 "cd ~/.virtualenvs/flutter/src" Enter
	tmux send-keys -t Flutter.0 "vi" Enter
	tmux send-keys -t Flutter.1 "cd ~/.virtualenvs/flutter/src" Enter "clear" Enter
	sleep 0.5
	tmux send-keys -t Flutter.0 ":cd ~/.virtualenvs/flutter/src" Enter
end

function divide_FluADB
	tmux select-window -t FluADB
	tmux split-window -d -t FluADB -v 

	tmux select-window -t FluADB

	sleep 0.5
	tmux send-keys -t FluADB.1 "adb-serv" Enter
	sleep 2
	tmux send-keys -t FluADB.0 "emul" Enter
	sleep 0.5
end

# exit를 위한 변수입니다
set flagFlutter 0
set flagADB 0

# vFlutter라는 이름을 가진 윈도우가 없으면 생성하고 vim을 실행시킵니다
if test "$(tmux has-session -t '0:Flutter' 2>/dev/null;and echo 1)" = '1'
	echo Flutter exist
	set flagFlutter 1
else
	echo Flutter created
	tmux new-window -d -n Flutter
	tmux split-window -d -t Flutter -v -p 25  #"workon misc"
	# divide_Flutter
end

# ADBemul 윈도우가 없으면 ADBemul 윈도우를 생성하고 emulator 및 adb server를 실행합니다
if test "$(tmux has-session -t '0:FluADB' 2>/dev/null; and echo 1)" = '1'
	echo FluADB exist
	set flagADB 1
else
	echo FluADB created
	tmux new-window -d -n FluADB
	# sleep 0.5
	# divide_FluADB

	# tmux select-window -t FluADB
	tmux split-window -d -t FluADB -v 
	# tmux select-window -t FluADB
	# sleep 0.5
	tmux send-keys -t FluADB.1 "adb-servoff" Enter
	echo 'Wait for adb-serv started...'
	sleep 4 
	tmux send-keys -t FluADB.1 "adb-serv" Enter
	# sleep 2
end


# async처럼 동작하는 것 같이 보이게 시간 딜레이를 최대한 줄여봅니다
# tmux send-keys -t FluADB.0 "emul" Enter
# sleep 0.5


# tmux select-window -t Flutter
tmux send-keys -t Flutter.0 "cd ~/.virtualenvs/flutter/src" Enter
tmux send-keys -t Flutter.0 "vi" Enter

sleep 2
tmux send-keys -t FluADB.0 "emul" Enter

tmux send-keys -t Flutter.1 "cd ~/.virtualenvs/flutter/src" Enter "clear" Enter
# sleep 0.5
tmux send-keys -t Flutter.0 ":cd ~/.virtualenvs/flutter/src" Enter

tmux select-window -t Flutter

