function __fish_ol_running_models
    ollama ps 2>/dev/null | tail -n +2 | awk '{print $1}'
end

complete -c ol \
    -n "__fish_seen_subcommand_from stop" \
    -a "(__fish_ol_running_models)" \
    -f

function __fish_ol_local_models
    # ollama list: 첫 컬럼이 모델 이름
    ollama list 2>/dev/null | tail -n +2 | awk '{print $1}'
end

# ol rm <TAB> => 설치된 모델 목록 완성
complete -c ol \
    -n "__fish_seen_subcommand_from rm" \
    -a "(__fish_ol_local_models)" \
    -f


# function __fish_ol_running_models ollama ps 2>/dev/null | tail -n +2 | awk '{print $1}'
# end

# complete -c ol \
#     -n "__fish_seen_subcommand_from stop" \
#     -a "(__fish_ol_running_models)"
