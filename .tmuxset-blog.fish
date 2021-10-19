# vBLOG라는 이름을 가진 윈도우를 생성하고 vim을 실행시킵니다
tmux new-window -d -n vBLOG

# 수평분할을 25%로 합니다 
tmux split-window -d -t vBLOG -v -p 25  

#blog을 가리키게 합니다. pyenv와 virtualenvwrapper를 통해 python3.6을 설치해보았습니다
tmux send-keys -t vBLOG.0 "vf activate blog" Enter
tmux send-keys -t vBLOG.0 "vf cd" Enter
tmux send-keys -t vBLOG.0 "cd src" Enter
tmux send-keys -t vBLOG.0 "vi --servername blog" Enter
tmux send-keys -t vBLOG.1 "vf activate blog" Enter
tmux send-keys -t vBLOG.0 ":Virtu" Tab Space "blog" Enter
tmux send-keys -t vBLOG.0 ":cd ~/.virtualenvs/blog/src" Enter
tmux send-keys -t vBLOG.1 "vf cd" Enter "cd src" Enter "clear" Enter

tmux select-window -t vBLOG

