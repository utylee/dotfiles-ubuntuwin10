function gptlast
    set -l logdir /mnt/g2/llm_logs
    set -l dbdir  $logdir/db
    set -l lastfile $logdir/.last

    if not test -f $lastfile
        echo "No last conversation."
        return 1
    end

    set -l name (string trim (cat $lastfile))
    if test -z "$name"
        echo "Last conversation is empty."
        return 1
    end

    set -l dbfile  $dbdir/$name.db
    set -l logfile $logdir/$name.log

    if not test -f $dbfile
        echo "No DB found for '$name' ($dbfile)"
        return 1
    end

    echo "Conversation: $name"
    # llm chat -m gpt-4o-mini -d $dbfile -c 2>&1 | tee -a $logfile
    llm chat -d $dbfile -c 2>&1 | tee -a $logfile
end
# function gptlast
#     set -l logdir /mnt/g2/llm_logs
#     set -l dbdir  $logdir/db
#     set -l lastfile $logdir/.last

#     if not test -f $lastfile
#         echo "No last conversation."
#         return 1
#     end

#     set -l name (cat $lastfile)
#     set -l dbfile $dbdir/$name.db
#     set -l logfile $logdir/$name.log

#     if not test -f $dbfile
#         echo "No DB found for '$name'"
#         return 1
#     end

#     echo "Conversation: $name"
#     llm chat -m gpt-4o-mini -d $dbfile -c 2>&1 | tee -a $logfile
# end
# function gptlast
#     set -l logdir /mnt/g2/llm_logs
#     set -l lastfile $logdir/.last

#     if not test -f $lastfile
#         echo "No last conversation found."
#         return 1
#     end

#     set -l conv (cat $lastfile)
#     echo "Conversation: $conv"
#     llm chat --conversation $conv | tee -a $logdir/$conv.log
# end
