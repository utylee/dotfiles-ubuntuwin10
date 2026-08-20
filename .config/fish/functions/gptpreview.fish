function gptpreview
    set -l name $argv[1]

    set -l logroot /mnt/g2/llm_logs
    set -l localdb ~/.cache/llm/db/$name.db
    set -l nasdb $logroot/db/$name.db
    set -l logfile $logroot/$name.log

	# echo "— Log tail (last 30 lines) —"
    # if test -f $logfile
        # tail -n 30 $logfile
    # else
        # echo "(no log)"
    # end

    echo "▶ $name"
    echo

    set -l has_local 0
    set -l has_nas 0

    if test -f $localdb
        set has_local 1
        set -l sz (du -h $localdb 2>/dev/null | awk '{print $1}')
        echo "Local DB : ✅ $sz"
    else
        echo "Local DB : ❌"
    end

    if test -f $nasdb
        set has_nas 1
        set -l sz (du -h $nasdb 2>/dev/null | awk '{print $1}')
        echo "NAS DB   : ✅ $sz"
    else
        echo "NAS DB   : ❌"
    end

    if test -f $logfile
        set -l sz (du -h $logfile 2>/dev/null | awk '{print $1}')
        echo "Log      : ✅ $sz"
    else
        echo "Log      : ❌"
    end

    echo

    # 👇 상태 요약 메시지
    if test $has_local -eq 1
        echo "🧠 Memory: READY (local DB)"
    else if test $has_nas -eq 1
        echo "🧠 Memory: AVAILABLE on NAS"
        echo "👉 Will auto-pull when opened"
    else
        echo "⚠️ Memory: NOT FOUND"
        echo "👉 This conversation will start fresh"
    end

    echo

    # 메시지 수(가능하면)
    if type -q sqlite3
        if test $has_local -eq 1
            set -l c (sqlite3 $localdb "select count(*) from messages;" 2>/dev/null)
            if test -n "$c"
                echo "Messages (local DB): $c"
            else
                echo "Messages (local DB): (unknown schema)"
            end
        else if test $has_nas -eq 1
            set -l c (sqlite3 $nasdb "select count(*) from messages;" 2>/dev/null)
            if test -n "$c"
                echo "Messages (NAS DB):   $c"
            else
                echo "Messages (NAS DB):   (unknown schema)"
            end
        end
        echo
    end

	echo "— Log tail (last 40 lines) —"
	if test -f $logfile
		tail -n 10 $logfile
	else
		echo "(no log)"
	end


    # echo "— Log tail —"
    # if test -f $logfile
    #     tail -n 12 $logfile
    # else
    #     echo "(no log)"
    # end
end
# function gptpreview
#     set -l name $argv[1]

#     set -l logroot /mnt/g2/llm_logs
#     set -l localdb ~/.cache/llm/db/$name.db
#     set -l nasdb $logroot/db/$name.db
#     set -l logfile $logroot/$name.log

#     echo "▶ $name"
#     echo

#     if test -f $localdb
#         set -l sz (du -h $localdb 2>/dev/null | awk '{print $1}')
#         echo "Local DB : ✅ $sz"
#     else
#         echo "Local DB : ❌"
#     end

#     if test -f $nasdb
#         set -l sz (du -h $nasdb 2>/dev/null | awk '{print $1}')
#         echo "NAS DB   : ✅ $sz"
#     else
#         echo "NAS DB   : ❌"
#     end

#     if test -f $logfile
#         set -l sz (du -h $logfile 2>/dev/null | awk '{print $1}')
#         echo "Log      : ✅ $sz"
#     else
#         echo "Log      : ❌"
#     end

#     echo

#     # 메시지 수(스키마가 다를 수 있으니 실패해도 넘어감)
#     if type -q sqlite3
#         if test -f $localdb
#             set -l c (sqlite3 $localdb "select count(*) from messages;" 2>/dev/null)
#             if test -n "$c"
#                 echo "Messages (local DB): $c"
#             else
#                 echo "Messages (local DB): (unknown schema)"
#             end
#         else if test -f $nasdb
#             set -l c (sqlite3 $nasdb "select count(*) from messages;" 2>/dev/null)
#             if test -n "$c"
#                 echo "Messages (NAS DB):   $c"
#             else
#                 echo "Messages (NAS DB):   (unknown schema)"
#             end
#         end
#         echo
#     end

#     echo "— Log tail —"
#     if test -f $logfile
#         tail -n 12 $logfile
#     else
#         echo "(no log)"
#     end
# end
