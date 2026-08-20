function gptls
    set -l logdir /mnt/g2/llm_logs

    if not test -d $logdir
        echo "Log directory not found: $logdir"
        return 1
    end

    # .log 목록을 최신순으로, 확장자 제거해서 출력
    for f in (ls -1t $logdir/*.log 2>/dev/null)
        echo (basename $f .log)
    end
end
# function gptls
#     set -l logdir /mnt/g2/llm_logs

#     if not test -d $logdir
#         return 0
#     end

#     ls -1t $logdir 2>/dev/null \
#     | string match -r '\.log$' \
#     | string replace -r '\.log$' ''
# end
# function gptls
#     set -l logdir /mnt/g2/llm_logs
#     ls -1t $logdir/*.log 2>/dev/null | sed 's#.*/##; s/\.log$//'
# end
# # function gptls
# #     ls -1t /mnt/g2/llm_logs | sed 's/\.log$//'
# # end
