# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples


#stty stop ''

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

PATH="$HOME/.local/bin:$PATH"
export TERM=xterm-256color-italic
# 윈도에서의 XWindowserver인 xming에서의 diplay를 설정해줘야합니다.
# vim에서의 client-server 기능의 동작을 위해서 필수입니다 (개인적으로 테스트해봤음)
export DISPLAY=:0
#export DISPLAY=localhost:0.0
# git editor를 vim으로 바꾸는 환경변수 차원의 방법이랍니다
export GIT_EDITOR=vim
export GPG_TTY=$(tty)

parse_git_branch() {
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# ts (tmux상에서 하단 창으로 send key를 통해서 vim에서 실행을 가능하게 해주는 함수를 입력해줍니다
# vimrc상에서도 설정해줘야합니다
source ~/.bash_functions

#function ts {
  #args=$@
  #tmux send-keys -t 1 "$args" Enter
#}

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
    xterm-256color-italic) color_prompt=yes;;
    xterm-256color-itali) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;31m\]$(parse_git_branch)\[\033[00m\]\$ '
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;31m\]$(parse_git_branch)\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alhF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# 각각 한/영/일 로 번역
alias td='tmux detach -a'
alias dt='tmux detach -a'
# dns lookup으로 속도가 느려서 직접 ip를 지정해주기로했습니다
#alias we='curl http://utylee.duckdns.org:9010;echo -e "\n"'
alias we='curl http://192.168.0.202:9010;echo -e "\n"'
#alias t='python ~/.virtualenvs/misc/src/translate_cmd.py ko '
#alias f='python ~/.virtualenvs/misc/src/translate_cmd.py en '
alias c='tmux rename-window "cmd";cmd.exe'
alias vi='vim'
#alias od='tmux rename-window "od";TERM=xterm-256color-italic ssh -p 8022 odroid@192.168.0.207'
#alias hc='tmux rename-window "hc";TERM=xterm-256color-italic ssh -X -p 8026 odroid@192.168.0.212'
#alias hc2='tmux rename-window "hc2";TERM=xterm-256color-italic ssh -X -p 8030 odroid@192.168.0.213'
alias od='tmux rename-window "od";TERM=xterm-256color-italic ssh -p 8821 odroid@192.168.0.201'
alias hc='tmux rename-window "hc";TERM=xterm-256color-italic ssh -X -p 8822 odroid@192.168.0.202'
alias hc2='tmux rename-window "hc2";TERM=xterm-256color-italic ssh -X -p 8823 odroid@192.168.0.203'
#alias od='ssh -p 8022 odroid@192.168.0.207'
#alias od='TERM=screen-256color-italic ssh -p 8022 odroid@192.168.0.207'
#alias pi='tmux rename-window "pi";TERM=xterm-256color-italic ssh -p 8023 pi@192.168.0.208 -t tmux a'
#alias pi='tmux rename-window "pi";TERM=xterm-256color-italic ssh -p 8023 pi@192.168.0.208'

#alias pi='tmux rename-window "pi";TERM=xterm-256color-italic ssh -p 8028 pi@192.168.0.211'
alias pi='tmux rename-window "pi";TERM=xterm-256color-italic ssh -p 8028 pi@192.168.0.221'

alias octo='tmux rename-window "octo";TERM=xterm-256color-italic ssh -p 8027 pi@192.168.0.117'
#alias pi2='tmux rename-window "pi2";TERM=xterm-256color-italic ssh -p 8024 pi@192.168.0.209 -t tmux a'
#alias pi2='tmux rename-window "pi2";TERM=xterm-256color-italic ssh -p 8024 pi@192.168.0.209'
alias pi2='tmux rename-window "pi2";TERM=xterm-256color-italic ssh -p 8024 pi@192.168.0.209'
#alias pi2='tmux rename-window "pi2";ssh -p 8024 pi@192.168.0.209'
alias pi3='tmux rename-window "pi3";TERM=xterm-256color-italic ssh -p 8025 pi@192.168.0.210'
#alias pi4='tmux rename-window "pi4";TERM=xterm-256color-italic ssh pi@192.168.0.211'
#alias mac='tmux rename-window "mac";TERM=xterm-256color-italic ssh utylee@192.168.0.107'
alias mac='tmux rename-window "mac";TERM=xterm-256color-italic ssh -p 8817 utylee@192.168.0.107'
alias wsl2='tmux rename-window "wsl2";TERM=xterm-256color-italic ssh -p 8824 utylee@192.168.0.204'
#alias mac='tmux rename-window "mac";TERM=xterm-256color-italic mosh --ssh "ssh -p 22" utylee@192.168.0.107'
#vWIN 에서 이름이 변경돼서 꼬이기 때문에 제거했습니다
#alias win='tmux rename-window "win";ssh utylee@localhost'
alias win='ssh utylee@localhost'

alias italic='echo `tput sitm`italic`tput ritm`'

alias tr0="source ~/.tmuxset-rust"
alias t1="source ~/.tmuxset-misc"
alias t0="source ~/.tmuxset-blog"
#alias t2="source ~/.tmuxset-flask"
alias t2="source ~/.tmuxset-win"
#alias t3="source ~/.tmuxset-trader"
alias t3="source ~/.tmuxset-tweb"
alias t4="source ~/.tmuxset-trsrv"
alias ta="source ~/.tmuxset-azeroth"
#windows ssh 연결후의 비밀번호를 입력하기 위한 별도의 단축키입니다(openssh와 방식이 달라서인지 ssh-copy-id가 되질 않습니다)
alias t3p='tmux send-keys -t vWIN.1 "sksmsqnwk11" Enter "workon win" Enter "cdvirtualenv"'

fix_wsl2_interop() {
    for i in $(pstree -np -s $$ | grep -o -E '[0-9]+'); do
        if [[ -e "/run/WSL/${i}_interop" ]]; then
            export WSL_INTEROP=/run/WSL/${i}_interop
        fi
    done
}

up() {
	/home/utylee/temp/youtube-upload/bin/youtube-upload --title="$2" --chunksize 1048576 "$1"
}

hos() {
	#python2 ~/temp/heroprotocol/heroprotocol.py --details "$1" > output.txt
	python -m heroprotocol --details "$1" > /mnt/e/hos_output.txt
}

# utylee copy
uc() {
	b="${1//\?/_u_qa_}"			# /이 한개면 한번만 //면 전체에서 교체입니다
	#b="${b//\%/_u_pe_}"		#%는 잘 받아지는 것 같습니다
	b="${b//\&/_u_im_}"
	b="${b//\ /_u_sp_}"
	curl http://192.168.0.202:9202/c/"$b"
	#curl http://192.168.0.212:9212/c/"$1"
	#curl http://utylee.duckdns.org:9212/c/"$1"
}
alias ua=uc

ur() {
	curl http://192.168.0.202:9202/r
}

uv() {
	curl http://192.168.0.202:9202/vt
}

m() {
	#echo $2 | mutt -s "$1" utylee@gmail.com -a "$3"
	echo $2 | mutt -s "$1" utylee@gmail.com 
}

ma() {
	echo $2 | mutt -s "$1" utylee@gmail.com -a "$3"
	#echo $2 | mutt -s "$1" utylee@gmail.com 
}

# cmd.exe shutdown
s() {
	cmd.exe /c "shutdown -s -t $1"
}
# abort
a() {
	cmd.exe /c "shutdown -a"
}
# reboot 
re() {
	cmd.exe /c "shutdown -r"
}

#for arduino, 해당시리얼포트 기기의 권한을 수정하여 사용할 수 있도록 합니다
p() {
	#echo $2 | mutt -s "$1" utylee@gmail.com -a "$3"
	echo sksmsqnwk11 | sudo -S chmod 777 /dev/ttyS4

}


samba() {
	echo sksmsqnwk11 | sudo -S mount -t drvfs '\\192.168.0.201\clark' /home/utylee/media/clark
	echo 
}

# usb remove drive by commandline

usboff() {
	~/Down/removedrive/x64/RemoveDrive.exe g:
}

usb() {
	echo sksmsqnwk11 | sudo -S mount -t drvfs g: /mnt/g
	echo
}

sim() {
	/home/utylee/.virtualenvs/misc/bin/python /home/utylee/.virtualenvs/misc/src/sim.py $1 $2 $3
}
#sim f, r, s
ra() {
	/home/utylee/.virtualenvs/misc/bin/python /home/utylee/.virtualenvs/misc/src/raider.py $1 $2 $3 
}
fx() {
	/home/utylee/.virtualenvs/misc/bin/python /home/utylee/.virtualenvs/misc/src/forex-test.py 0 $1
}
xf() {
	/home/utylee/.virtualenvs/misc/bin/python /home/utylee/.virtualenvs/misc/src/forex-test.py 1 $1
}

b() {
	lua /home/utylee/temp/wowaddon/bfa.lua
}

#translate-shell
t() {
	trans -b $1
}

tt() {
	trans $1
}

f() {
	trans -b $1 :en
}

	

vir() {
	filename=$PWD/$1
	tmux send-keys -t vRust.0 ":e $filename" C-m
	tmux select-window -t vRust
	tmux select-pane -t vRust.0
}
vi0() {
	filename=$PWD/$1
	tmux send-keys -t vBLOG.0 ":e $filename" C-m
	tmux select-window -t vBLOG
	tmux select-pane -t vBLOG.0
}
vi1() {
	filename=$PWD/$1
	tmux send-keys -t vMISC.0 ":e $filename" C-m
	tmux select-window -t vMISC
	tmux select-pane -t vMISC.0
}
vi4() {
	filename=$PWD/$1
	tmux send-keys -t vTRADER.0 ":e $filename" C-m
	tmux select-window -t vTRADER
	tmux select-pane -t vTRADER.0
}
vi2() {
	filename=$PWD/$1
	tmux send-keys -t vWIN.0 ":e $filename" C-m
	tmux select-window -t vWIN
	tmux select-pane -t vWIN.0
}
vi3() {
	filename=$PWD/$1
	tmux send-keys -t vTRWEB.0 ":e $filename" C-m
	tmux select-window -t vTRWEB
	tmux select-pane -t vTRWEB.0
}
vi4() {
	filename=$PWD/$1
	tmux send-keys -t vTRSRV.0 ":e $filename" C-m
	tmux select-window -t vTRSRV
	tmux select-pane -t vTRSRV.0
}
# wow에서 던전에서 필요없는 애드온을 임시로 뺴놓습니다. 애드온 사용 언첵할 필요없이
#	저렇게 빼놓은 후 reload addon 을 하는 것만으로도 사용량이 없어지는 것을 addons cpu usage에서 확인하였습니다
addout() {
	mv /mnt/c/Program\ Files\ \(x86\)/World\ of\ Warcraft/_retail_/Interface/AddOns/HandyNotes /mnt/c/Temp/
	mv /mnt/c/Program\ Files\ \(x86\)/World\ of\ Warcraft/_retail_/Interface/AddOns/GatherMate2 /mnt/c/Temp/
	mv /mnt/c/Program\ Files\ \(x86\)/World\ of\ Warcraft/_retail_/Interface/AddOns/Auctionator/ /mnt/c/Temp/
	mv /mnt/c/Program\ Files\ \(x86\)/World\ of\ Warcraft/_retail_/Interface/AddOns/Paku_Totems/ /mnt/c/Temp/
	#mv /mnt/c/Program\ Files\ \(x86\)/World\ of\ Warcraft/_retail_/Interface/AddOns/ACU/ /mnt/c/Temp/
	mv /mnt/c/Program\ Files\ \(x86\)/World\ of\ Warcraft/_retail_/Interface/AddOns/AAP-Core/ /mnt/c/Temp/
	mv /mnt/c/Program\ Files\ \(x86\)/World\ of\ Warcraft/_retail_/Interface/AddOns/WorldQuestTracker/ /mnt/c/Temp/
	mv /mnt/c/Program\ Files\ \(x86\)/World\ of\ Warcraft/_retail_/Interface/AddOns/Overachiever/ /mnt/c/Temp/
	mv /mnt/c/Program\ Files\ \(x86\)/World\ of\ Warcraft/_retail_/Interface/AddOns/Accountant_Classic/ /mnt/c/Temp/
	mv /mnt/c/Program\ Files\ \(x86\)/World\ of\ Warcraft/_retail_/Interface/AddOns/TradeSkillMaster/ /mnt/c/Temp/
}
addin() {
	mv /mnt/c/Temp/HandyNotes /mnt/c/Program\ Files\ \(x86\)/World\ of\ Warcraft/_retail_/Interface/AddOns/
	mv /mnt/c/Temp/GatherMate2 /mnt/c/Program\ Files\ \(x86\)/World\ of\ Warcraft/_retail_/Interface/AddOns/
	mv /mnt/c/Temp/Auctionator /mnt/c/Program\ Files\ \(x86\)/World\ of\ Warcraft/_retail_/Interface/AddOns/
	mv /mnt/c/Temp/Paku_Totems /mnt/c/Program\ Files\ \(x86\)/World\ of\ Warcraft/_retail_/Interface/AddOns/
	#mv /mnt/c/Temp/ACU /mnt/c/Program\ Files\ \(x86\)/World\ of\ Warcraft/_retail_/Interface/AddOns/
	mv /mnt/c/Temp/AAP-Core /mnt/c/Program\ Files\ \(x86\)/World\ of\ Warcraft/_retail_/Interface/AddOns/
	mv /mnt/c/Temp/WorldQuestTracker /mnt/c/Program\ Files\ \(x86\)/World\ of\ Warcraft/_retail_/Interface/AddOns/
	mv /mnt/c/Temp/Overachiever /mnt/c/Program\ Files\ \(x86\)/World\ of\ Warcraft/_retail_/Interface/AddOns/
	mv /mnt/c/Temp/Accountant_Classic/ /mnt/c/Program\ Files\ \(x86\)/World\ of\ Warcraft/_retail_/Interface/AddOns/
	mv /mnt/c/Temp/TradeSkillMaster/ /mnt/c/Program\ Files\ \(x86\)/World\ of\ Warcraft/_retail_/Interface/AddOns/
}

bye() {
	cd ~/utylee/goodbyedpi-0.1.5/x86_64/
	./goodbyedpi.exe -1
}

a0() {
	cd ~/utylee 
	audioswitch.exe 0
	cd - 2 > /dev/null
	echo 'digital'
}
a1() {
	cd ~/utylee 
	audioswitch.exe 2
	cd - 2 > /dev/null
	echo 'USB Focusrite'
}
a2() {
	cd ~/utylee 
	audioswitch.exe 1
	cd - 2 > /dev/null
	echo 'Realtek'
}

#alias vi0="vim --servername blog --remote "
#alias vi1="vim --servername misc --remote "
#alias vi2="vim --servername flask --remote "
#alias vi1="vim --REMOTE misc"
#alias a0='cd ~ ;audioswitch.exe 0 ;cd -'	# realtek
#alias a1='audioswitch.exe 1'	# focusrite
#alias a2='audioswitch.exe 2'	# focusrite

alias mygrep="grep -rn . --exclude={*.o,*.a,tags} -e "

#export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"
export PYENV_ROOT="$HOME/.pyenv"

#export PATH="/usr/local/clang_7.0.1/bin:/mnt/c/Users/.virtualenvs/win/Scripts/:$HOME/temp/arduino-proj:$HOME/temp/arduino:$PYENV_ROOT/bin:$PATH"
#export PATH="/usr/local/clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-16.04/bin:/mnt/c/Users/.virtualenvs/win/Scripts/:$HOME/temp/arduino-proj:$HOME/temp/arduino:$PYENV_ROOT/bin:$PATH"
#export PATH="/usr/local/clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-16.04/bin:/mnt/c/Users/.virtualenvs/win/Scripts/:$HOME/temp/arduino-proj:$HOME/temp/arduino:$PYENV_ROOT/bin:$PATH"
export CLANGHOME=/usr/local/clang+llvm-11.0.1-x86_64-linux-gnu-ubuntu-16.04
export PATH=$CLANGHOME/bin:$HOME/.cargo/bin:/mnt/c/Users/.virtualenvs/win/Scripts/:$HOME/temp/arduino-proj:$HOME/temp/arduino:$PYENV_ROOT/bin:$PATH
#export PATH=/usr/local/clang_11.0.0/bin:$PATH
#export CC=/usr/local/clang_11.0.0/bin/clang
#export CXX=/usr/local/clang_11.0.0/bin/clang++
export CC=$CLANGHOME/bin/clang
export CXX=$CLANGHOME/bin/clang++
export LD_LIBRARY_PATH="$CLANGHOME/lib:$LD_LIBRARY_PATH"
#export LD_LIBRARY_PATH=/usr/local/clang_11.0.0/lib
export PATH="/home/utylee/.pyenv/shims:$PATH"
eval "$(pyenv init -)"

# blinking cursor
echo -ne "\x1b[1 q"

# pyenv-virtualenvwrapper sh를 실행하는 듯 합니다. cdv- mkv- workon 등을 사용할 수 있습니다
# 로딩시간이 좀 걸리는 게 문제입니다 ^^
pyenv virtualenvwrapper_lazy

source ~/.solarized.dark
#source ~/.solarized.light

export LC_ALL=ko_KR.UTF-8

export FZF_COMPLETION_TRIGGER='**'
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --no-ignore'
export FZF_CTRL_T_COMMAND='rg --files --hidden --follow --no-ignore'
#export FZF_DEFAULT_COMMAND='ag --hidden --path-to-ignore ~/.ignore -g ""'
#export FZF_CTRL_T_COMMAND='ag --hidden --path-to-ignore ~/.ignore -g ""'

### <191206 
#export FZF_CTRL_T_COMMAND='rg --files /home/utylee --hidden --follow --no-ignore'
#export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob ""'
### --->

#export FZF_DEFAULT_COMMAND='ag --hidden -g ""'
#export FZF_DEFAULT_COMMAND='ag -g ""'
#alias ag='ag --hidden --path-to-ignore ~/.ignore '
#export FZF_DEFAULT_COMMAND='ag --hidden --ignore "*tags" --ignore={"*css","*min.css","*min.js"} -g ""'
#export FZF_DEFAULT_COMMAND='ag --hidden -g ""'
#export FZF_DEFAULT_COMMAND='ag'
#alias ag='ag --hidden --ignore={"*tags","*css","*min.css","*min.js"} -g ""'
#alias ag='ag --path-to-ignore /home/odroid/.ignore'
#export FZF_DEFAULT_COMMAND='ag --hidden --path-to-ignore ~/.ignore -g ""'
#export FZF_DEFAULT_COMMAND='ag -l --path-to-ignore ~/.ignore --nocolor --hidden -g ""'

#export FZF_DEFAULT_COMMAND='ag --ignore={"*json","*.min.css","*.min.js"}'
#source ~/qmk_utils/activate_wsl.sh

fix_wsl2_interop
