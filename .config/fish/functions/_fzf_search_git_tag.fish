function _fzf_search_git_tag
    set tag (
        git for-each-ref --sort=-creatordate refs/tags \
            --format='%(refname:short)' |
        _fzf_wrapper --ansi \
            --tiebreak=index \
            --preview 'git show --color=always --stat -n 1 {}' \
            --reverse \
            --query=(commandline --current-token) \
            $fzf_git_tag_opts
    )

    if test $status -eq 0; and test -n "$tag"
        commandline --current-token --replace -- (string escape -- $tag)
    end

    commandline --function repaint
end
