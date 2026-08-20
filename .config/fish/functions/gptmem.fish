function gptmem
    set -l logdir /mnt/g2/llm_logs
    set -l dbdir  $logdir/db
    mkdir -p $logdir $dbdir

    if test (count $argv) -lt 1
        echo "Usage: gptmem <name>"
        return 1
    end

    set -l name $argv[1]
    set -l memfile $logdir/$name.mem.md
    set -l dbfile  $dbdir/$name.db
    set -l logfile $logdir/$name.log

    if not test -f $memfile
        echo "Memory file not found: $memfile"
        echo "Run: gpts $name"
        return 1
    end

    echo $name > $logdir/.last
    echo "Conversation: $name (with mem)"

    # 메모를 시스템 프롬프트로 주고 시작/이어가기
    set -l sys (cat $memfile)

    if test -f $dbfile
        # llm chat -m gpt-4o-mini -d $dbfile -c -s "$sys" 2>&1 | tee -a $logfile
        llm chat -d $dbfile -c -s "$sys" 2>&1 | tee -a $logfile
    else
        # llm chat -m gpt-4o-mini -d $dbfile -s "$sys" 2>&1 | tee -a $logfile
        llm chat -d $dbfile -s "$sys" 2>&1 | tee -a $logfile
    end
end
# function gptmem
#     set -l logdir /mnt/g2/llm_logs
#     mkdir -p $logdir

#     if test (count $argv) -lt 1
#         echo "Usage: gptmem <conversation>"
#         return 1
#     end

#     set -l conv $argv[1]
#     set -l mem $logdir/$conv.mem.md

#     echo $conv > $logdir/.last
#     echo "Conversation: $conv"

#     if test -f $mem
#         llm chat --conversation $conv --system (cat $mem) | tee -a $logdir/$conv.log
#     else
#         echo "(No memory file: $mem)"
#         llm chat --conversation $conv | tee -a $logdir/$conv.log
#     end
# end
