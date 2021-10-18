if status is-interactive
    # Commands to run in interactive sessions can go here
end

set fish_greeting ''
fish_vi_key_bindings
set -x PATH $PATH /usr/local/node-v14.18.1-linux-x64/bin /mnt/c/Windows/System32 /mnt/c/Windows/System32/WindowsPowrShell/v1.0/ /mnt/c/Python310/ /mnt/c/Python310/Scripts
set -gx FZF_DEFAULT_COMMAND 'rg --files --hidden --follow --no-ignore'
set -gx FZF_CTRL_T_COMMAND "rg --files --hidden --follow --no-ignore"
#set -U pure_enable_single_line_prompt true

starship init fish | source
