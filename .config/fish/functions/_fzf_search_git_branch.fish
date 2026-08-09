function _fzf_search_git_branch
    set branch (
        git for-each-ref --sort=-committerdate refs/heads refs/remotes \
            --format='%(refname:short)' |
        string replace -r '^origin/' '' |
        awk '!seen[$0]++' |
        _fzf_wrapper --ansi \
            --tiebreak=index \
            --preview 'git log --oneline --graph --decorate --color=always -n 40 {}' \
            --reverse \
            --query=(commandline --current-token) \
            $fzf_git_branch_opts
    )

    if test $status -eq 0; and test -n "$branch"
        commandline --current-token --replace -- (string escape -- $branch)
    end

    commandline --function repaint
end

# function _fzf_search_git_branch
#     set branch (git for-each-ref --sort=-committerdate refs/heads/ \
#         --format='%(refname:short)' | fzf --height 40% --reverse)
#     if test -n "$branch"
#         git checkout $branch
#     end
#     commandline --function repaint
# end
