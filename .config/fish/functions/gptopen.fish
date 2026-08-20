function gptopen
    set -l logroot /mnt/g2/llm_logs
    set -l metadir $logroot/.meta
    set -l nasdb   $logroot/db
    set -l localdb ~/.cache/llm/db
    mkdir -p $logroot $metadir $nasdb $localdb

    if test (count $argv) -lt 1
        echo "Usage: gptopen <name>"
        return 1
    end

    set -l name $argv[1]
    set -l localfile $localdb/$name.db
    set -l logfile   $logroot/$name.log

    if not test -f $logfile
        echo "Log not found: $logfile"
        return 1
    end

    # 핵심: 로컬 DB 없으면 NAS에서 pull
    if not test -f $localfile
        if test -f $nasdb/$name.db
            echo "Local DB missing → pulling from NAS..."
            rsync -a $nasdb/$name.db $localfile
            or echo "⚠️ pull failed: $nasdb/$name.db"
        else
            echo "⚠️ No DB found (local/NAS). This will start fresh."
        end
    end

    echo $name > $logroot/.last
    echo "Open conversation: $name"

	set -l ctx 10  # 여기 숫자만 바꾸면 됨

	echo ""
	echo "— Context (last $ctx lines) —"
	tail -n $ctx $logfile 2>/dev/null
	echo "----------------------------"
	echo ""

    env PYTHONUTF8=1 PYTHONIOENCODING=utf-8:replace \
      # llm chat -m gpt-4o-mini -d $localfile 2>&1 | tee -a $logfile
      # llm chat -d $localfile 2>&1 | tee -a $logfile
	  # llm chat -c -m gpt-4o-mini -d $localfile 2>&1 | tee -a $logfile
	  llm chat -c -d $localfile 2>&1 | tee -a $logfile

    # --- hooks (fail-loud, log) ---
    set -l cur (string trim (cat $logroot/.last))
    echo (date "+%F %T")" [gptopen] exit hooks begin cur=$cur" >> $metadir/hooks.log

    if string match -qr '^chat-[0-9]{8}-[0-9]{6}$' -- $cur
        gptsave --auto $cur
        or begin
            echo "⚠️ autosave(rename) failed: $cur"
            echo (date "+%F %T")" [gptopen] gptsave --auto FAILED cur=$cur" >> $metadir/hooks.log
        end
    end

    gptpush
    or begin
        echo "⚠️ autopush failed (NAS mount?)"
        echo (date "+%F %T")" [gptopen] gptpush FAILED cur="(string trim (cat $logroot/.last)) >> $metadir/hooks.log
    end

    echo (date "+%F %T")" [gptopen] exit hooks end last="(string trim (cat $logroot/.last)) >> $metadir/hooks.log
end
# function gptopen
#     set -l logroot /mnt/g2/llm_logs
#     set -l nasdb   $logroot/db
#     set -l localdb ~/.cache/llm/db
#     mkdir -p $localdb

#     if test (count $argv) -lt 1
#         echo "Usage: gptopen <name>"
#         return 1
#     end

#     set -l name $argv[1]
#     set -l localfile $localdb/$name.db
#     set -l logfile   $logroot/$name.log

#     if not test -f $logfile
#         echo "Log not found: $logfile"
#         return 1
#     end

#     # 🔑 핵심: 로컬 DB 없으면 NAS에서 자동 pull
#     if not test -f $localfile
#         if test -f $nasdb/$name.db
#             echo "Local DB missing, pulling from NAS..."
#             rsync -a $nasdb/$name.db $localfile
#         else
#             echo "No DB found (local or NAS). Starting fresh."
#         end
#     end

#     echo $name > $logroot/.last
#     echo "Open conversation: $name"

#     env PYTHONUTF8=1 PYTHONIOENCODING=utf-8:replace \
#       llm chat -m gpt-4o-mini -d $localfile 2>&1 | tee -a $logfile

#     # 종료 후 자동 저장/푸시
#     set -l cur (string trim (cat $logroot/.last))
#     if string match -qr '^chat-[0-9]{8}-[0-9]{6}$' -- $cur
#         gptsave --auto $cur >/dev/null 2>&1
#     end
#     gptpush >/dev/null 2>&1
# end

# function gptopen
#     set -l logroot /mnt/g2/llm_logs
#     set -l localdb ~/.cache/llm/db
#     mkdir -p $logroot $localdb

#     if test (count $argv) -lt 1
#         echo "Usage: gptopen <name>"
#         return 1
#     end

#     set -l name $argv[1]
#     set -l localfile $localdb/$name.db
#     set -l logfile   $logroot/$name.log

#     if not test -f $localfile
#         echo "Local DB not found: $localfile"
#         echo "Hint: gptpull $name"
#         return 1
#     end

#     echo $name > $logroot/.last
#     echo "Open conversation: $name"

#     env PYTHONUTF8=1 PYTHONIOENCODING=utf-8:replace \
#       llm chat -m gpt-4o-mini -d $localfile 2>&1 | tee -a $logfile

#     set -l cur (string trim (cat $logroot/.last))
#     if string match -qr '^chat-[0-9]{8}-[0-9]{6}$' -- $cur
#         gptsave --auto $cur >/dev/null 2>&1
#     end

#     gptpush >/dev/null 2>&1
# end
# function gptopen
#     set -l logroot /mnt/g2/llm_logs
#     set -l nasdb   $logroot/db
#     set -l localdb ~/.cache/llm/db
#     mkdir -p $nasdb $localdb

#     if test (count $argv) -lt 1
#         echo "Usage: gptopen <name>"
#         return 1
#     end

#     set -l name $argv[1]
#     set -l localfile $localdb/$name.db
#     set -l logfile   $logroot/$name.log

#     if not test -f $localfile
#         echo "Local DB not found: $localfile"
#         echo "Hint: gptpull $name"
#         return 1
#     end

#     echo $name > $logroot/.last
#     echo "Open conversation: $name"

#     env PYTHONUTF8=1 PYTHONIOENCODING=utf-8:replace \
#       # llm chat -m gpt-4o-mini -d $localfile 2>&1 | tee -a $logfile
#       llm chat -d $localfile 2>&1 | tee -a $logfile
# end
# function gptopen
#     set -l logdir /mnt/g2/llm_logs
#     set -l dbdir  $logdir/db
#     mkdir -p $logdir $dbdir

#     if test (count $argv) -lt 1
#         echo "Usage: gptopen <name>"
#         return 1
#     end

#     set -l name $argv[1]
#     set -l dbfile  $dbdir/$name.db
#     set -l logfile $logdir/$name.log

#     if not test -f $dbfile
#         echo "No DB found for '$name' ($dbfile)"
#         return 1
#     end

#     echo $name > $logdir/.last
#     echo "Open conversation: $name"

#     # llm chat -m gpt-4o-mini -d $dbfile -c 2>&1 | tee -a $logfile
#     llm chat -d $dbfile -c 2>&1 | tee -a $logfile
# end
