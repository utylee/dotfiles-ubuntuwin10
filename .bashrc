# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

#stty stop ''

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

export TERM=xterm-256color-italic
# 윈도에서의 XWindowserver인 xming에서의 diplay를 설정해줘야합니다.
# vim에서의 client-server 기능의 동작을 위해서 필수입니다 (개인적으로 테스트해봤음)
#export DISPLAY=:0
export DISPLAY=localhost:0.0

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
alias t='python ~/.virtualenvs/misc/src/translate_cmd.py ko '
alias f='python ~/.virtualenvs/misc/src/translate_cmd.py en '
alias j='python ~/.virtualenvs/misc/src/translate_cmd.py ja '
alias vi='vim'
alias od='tmux rename-window "od";TERM=xterm-256color-italic ssh -p 8022 odroid@192.168.0.207'
#alias od='ssh -p 8022 odroid@192.168.0.207'
#alias od='TERM=screen-256color-italic ssh -p 8022 odroid@192.168.0.207'
#alias pi='tmux rename-window "pi";TERM=xterm-256color-italic ssh -p 8023 pi@192.168.0.208 -t tmux a'
alias pi='tmux rename-window "pi";TERM=xterm-256color-italic ssh -p 8023 pi@192.168.0.208'
#alias pi2='tmux rename-window "pi2";TERM=xterm-256color-italic ssh -p 8024 pi@192.168.0.209 -t tmux a'
alias pi2='tmux rename-window "pi2";TERM=xterm-256color-italic ssh -p 8024 pi@192.168.0.209'
alias pi3='tmux rename-window "pi3";TERM=xterm-256color-italic ssh -p 8025 pi@192.168.0.210'
alias mac='tmux rename-window "mac";TERM=xterm-256color-italic ssh utylee@192.168.0.107'
#vWIN 에서 이름이 변경돼서 꼬이기 때문에 제거했습니다
#alias win='tmux rename-window "win";ssh utylee@localhost'
alias win='ssh utylee@localhost'

alias italic='echo `tput sitm`italic`tput ritm`'

alias t1="source ~/.tmuxset-misc"
alias t0="source ~/.tmuxset-blog"
alias t2="source ~/.tmuxset-flask"
alias t3="source ~/.tmuxset-win"
alias ta="source ~/.tmuxset-azeroth"
#windows ssh 연결후의 비밀번호를 입력하기 위한 별도의 단축키입니다(openssh와 방식이 달라서인지 ssh-copy-id가 되질 않습니다)
alias t3p='tmux send-keys -t vWIN.1 "sksmsqnwk11" Enter "workon win" Enter "cdvirtualenv"'

m() {
	echo $2 | mutt -s "$1" utylee@gmail.com -a "$3"
}

alias vi0="vim --servername blog --remote "
alias vi1="vim --servername misc --remote "
#alias vi1="vim --REMOTE misc"

alias mygrep="grep -rnw . --exclude=*.{o,a} -e "

#export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# pyenv-virtualenvwrapper sh를 실행하는 듯 합니다. cdv- mkv- workon 등을 사용할 수 있습니다
# 로딩시간이 좀 걸리는 게 문제입니다 ^^
pyenv virtualenvwrapper_lazy

source ~/.solarized.dark
#source ~/.solarized.light

