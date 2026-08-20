function gpto
    if not type -q fzf
        echo "Install fzf: sudo apt install fzf"
        return 1
    end

    set -l names (gptls)
    if test (count $names) -eq 0
        echo "No conversations."
        return 1
    end

    # fish -lc 로 login shell 컨텍스트에서 함수 로드
    set -l choice (printf "%s\n" $names | fzf \
        --prompt="Select conversation> " \
        --preview='fish -lc "gptpreview {}"' \
		--preview-window='right:60%:wrap:follow' \
        # --preview-window='right:60%:wrap' \
        --bind='ctrl-u:preview-page-up,ctrl-d:preview-page-down')

    test -z "$choice"; and return 1
    gptopen $choice
end
# function gpto
#     set -l names (gptls)
#     if test (count $names) -eq 0
#         echo "No conversations found."
#         return 1
#     end

#     set -l choice ""

#     if type -q fzf
#         set choice (printf "%s\n" $names | fzf --prompt="Select conversation> ")
#     else
#         echo "Select conversation:"
#         set -l i 1
#         for n in $names
#             echo "  $i) $n"
#             set i (math $i + 1)
#         end
#         read -P "Enter number> " idx
#         if test -z "$idx"
#             return 1
#         end
#         set choice $names[$idx]
#     end

#     if test -z "$choice"
#         return 1
#     end

#     gptopen $choice
# end
# function gpto
#     set -l logdir /mnt/g2/llm_logs
#     set -l dbdir  $logdir/db
#     mkdir -p $logdir $dbdir

#     set -l names (gptls)
#     if test (count $names) -eq 0
#         echo "No conversations found."
#         return 1
#     end

#     set -l choice ""

#     if type -q fzf
#         set choice (printf "%s\n" $names | fzf --prompt="Select conversation> ")
#     else
#         echo "Select conversation:"
#         set -l i 1
#         for n in $names
#             echo "  $i) $n"
#             set i (math $i + 1)
#         end
#         read -P "Enter number> " idx
#         if test -z "$idx"
#             return 1
#         end
#         set choice $names[$idx]
#     end

#     if test -z "$choice"
#         return 1
#     end

#     # 선택한 이름으로 gpt 실행
#     gpt $choice
# end
# function gpto
#     set -l logdir /mnt/g2/llm_logs

#     if not test -d $logdir
#         echo "Log dir not found: $logdir"
#         return 1
#     end

#     set -l conv (ls -1t $logdir 2>/dev/null \
#         | string match -r '\.log$' \
#         | string replace -r '\.log$' '' \
#         | fzf --prompt="GPT> " --height=40% --reverse)

#     if test -z "$conv"
#         return 0
#     end

#     # last 업데이트
#     echo $conv > $logdir/.last
#     echo "Conversation: $conv"
#     llm chat --conversation $conv | tee -a $logdir/$conv.log
# end
