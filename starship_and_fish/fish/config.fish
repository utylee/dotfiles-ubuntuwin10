if status is-interactive
    # Commands to run in interactive sessions can go here
	# CURSOR
	echo -ne '\eP\e]12;#207dab\a'	# wsl1
	#echo -ne '\eP\e]12;#e034a1\a'	# wsl2
end

set fish_greeting ''
fish_vi_key_bindings

#set -gx EDITOR /usr/bin/vi

# PATH
set CLANGHOME /usr/local/clang+llvm-12.0.1-x86_64-linux-gnu-ubuntu-16.04
set -x PATH $PATH $CLANGHOME/bin
set -x PATH $PATH /usr/local/node-v14.18.1-linux-x64/bin /mnt/c/Windows/System32/WindowsPowrShell/v1.0/ /mnt/c/Python310/ /mnt/c/Python310/Scripts
set -gx CC $CLANGHOME/bin/clang
set -gx CXX $CLANGHOME/bin/clang++
set -gx LD_LIBRARY_PATH $LD_LIBRARY_PATH $CLANGHOME/lib 

# FZF
set -gx FZF_DEFAULT_COMMAND "rg --files --hidden --follow --no-ignore"
#set -gx FZF_CTRL_T_COMMAND "rg --files --hidden --follow --no-ignore"
set -gx FZF_CTRL_T_COMMAND "find . -depth"
set -gx FZF_ALT_C_COMMAND "find . -depth"
#set -gx FZF_ALT_C_COMMAND "rg --hidden --files --null | xargs -0 dirname | uniq"
#set -gx FZF_ALT_C_COMMAND "rg --hidden --sort-files --files --null 2> /dev/null | xargs -0 dirname | uniq"

# VENV
set -gx WORKON_HOME $HOME/.virtualenvs


starship init fish | source
