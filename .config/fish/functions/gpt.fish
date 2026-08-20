function gpt
    set -l logroot /mnt/g2/llm_logs
    set -l metadir $logroot/.meta
    set -l nasdb   $logroot/db
    set -l localdb ~/.cache/llm/db
    mkdir -p $logroot $metadir $nasdb $localdb

    set -l name chat-(date "+%Y%m%d-%H%M%S")
    set -l logfile $logroot/$name.log
    set -l dbfile  $localdb/$name.db

    echo $name > $logroot/.last
    echo "New conversation: $name"

    env PYTHONUTF8=1 PYTHONIOENCODING=utf-8:replace \
      # llm chat -m gpt-4o-mini -d $dbfile 2>&1 | tee -a $logfile
      llm chat -d $dbfile 2>&1 | tee -a $logfile

    # --- hooks (fail-loud, log) ---
    set -l cur (string trim (cat $logroot/.last))
    echo (date "+%F %T")" [gpt] exit hooks begin cur=$cur" >> $metadir/hooks.log

    if string match -qr '^chat-[0-9]{8}-[0-9]{6}$' -- $cur
        gptsave --auto $cur
        or begin
            echo "⚠️ autosave(rename) failed: $cur"
            echo (date "+%F %T")" [gpt] gptsave --auto FAILED cur=$cur" >> $metadir/hooks.log
        end
    end

    gptpush
    or begin
        echo "⚠️ autopush failed (NAS mount?)"
        echo (date "+%F %T")" [gpt] gptpush FAILED cur="(string trim (cat $logroot/.last)) >> $metadir/hooks.log
    end

    echo (date "+%F %T")" [gpt] exit hooks end last="(string trim (cat $logroot/.last)) >> $metadir/hooks.log
end
# function gpt
#     set -l logroot /mnt/g2/llm_logs
#     set -l nasdb   $logroot/db
#     set -l localdb ~/.cache/llm/db
#     mkdir -p $logroot $nasdb $localdb

#     set -l name chat-(date "+%Y%m%d-%H%M%S")
#     set -l logfile $logroot/$name.log
#     set -l dbfile  $localdb/$name.db

#     echo $name > $logroot/.last
#     echo "New conversation: $name"

#     env PYTHONUTF8=1 PYTHONIOENCODING=utf-8:replace \
#       llm chat -m gpt-4o-mini -d $dbfile 2>&1 | tee -a $logfile

#     # exit 후: 아직 임시제목이면 자동 저장(=rename) 1회
#     set -l cur (string trim (cat $logroot/.last))
#     if string match -qr '^chat-[0-9]{8}-[0-9]{6}$' -- $cur
#         gptsave --auto $cur >/dev/null 2>&1
#     end

#     # 마지막 이름 기준 자동 push
#     gptpush >/dev/null 2>&1
# end
# function gpt
#     set -l logroot /mnt/g2/llm_logs
#     set -l logdir  $logroot
#     set -l nasdb   $logroot/db
#     set -l localdb ~/.cache/llm/db
#     mkdir -p $logdir $nasdb $localdb

#     set -l name chat-(date "+%Y%m%d-%H%M%S")
#     set -l logfile $logdir/$name.log
#     set -l dbfile  $localdb/$name.db

#     echo $name > $logdir/.last
#     echo "New conversation: $name"

#     env PYTHONUTF8=1 PYTHONIOENCODING=utf-8:replace \
#       # llm chat -m gpt-4o-mini -d $dbfile 2>&1 | tee -a $logfile
#       llm chat -d $dbfile 2>&1 | tee -a $logfile
# end
# function gpt
#     set -l logdir /mnt/g2/llm_logs
#     set -l dbdir  $logdir/db
#     mkdir -p $logdir $dbdir

#     set -l name chat-(date "+%Y%m%d-%H%M%S")
#     set -l logfile $logdir/$name.log
#     set -l dbfile  $dbdir/$name.db

#     echo $name > $logdir/.last

#     echo (date "+%H:%M:%S.%3N")" [gpt] new: $name"

#     # llm 출력 모든 줄에 ms 타임스탬프 부착 + 파일에도 저장
#     llm chat -m gpt-4o-mini -d $dbfile 2>&1 \
#       | awk '{ cmd="date +%H:%M:%S.%3N"; cmd | getline t; close(cmd); print t, $0; fflush(); }' \
#       | tee -a $logfile
# end
# function gpt
#     set -l logdir /mnt/g2/llm_logs
#     set -l dbdir  $logdir/db
#     mkdir -p $logdir $dbdir

#     set -l name chat-(date "+%Y%m%d-%H%M%S")
#     set -l logfile $logdir/$name.log
#     set -l dbfile  $dbdir/$name.db

#     echo $name > $logdir/.last

#     echo (date "+%H:%M:%S.%3N")" [1] created name: $name"
#     echo (date "+%H:%M:%S.%3N")" [2] starting llm..."

#     llm chat -m gpt-4o-mini -d $dbfile 2>&1 | tee -a $logfile
# end
# function gpt
#     set -l logdir /mnt/g2/llm_logs
#     set -l dbdir  $logdir/db
#     mkdir -p $logdir $dbdir

#     set -l name chat-(date "+%Y%m%d-%H%M%S")
#     set -l logfile $logdir/$name.log
#     set -l dbfile  $dbdir/$name.db

#     echo $name > $logdir/.last

#     echo (date "+%H:%M:%S")" [1] created name: $name"
#     echo (date "+%H:%M:%S")" [2] starting llm..."  # <- 여기서 멈추는지 확인

#     # 일단 tee로 가던 script로 가던, 우선 "llm 실행 직전" 타임스탬프가 핵심
#     llm chat -m gpt-4o-mini -d $dbfile 2>&1 | tee -a $logfile
# end
# function gpt
#     set -l logdir /mnt/g2/llm_logs
#     set -l dbdir  $logdir/db
#     mkdir -p $logdir $dbdir

#     set -l name chat-(date "+%Y%m%d-%H%M%S")
#     set -l logfile $logdir/$name.log
#     set -l dbfile  $dbdir/$name.db

#     echo $name > $logdir/.last
#     echo "New conversation: $name"

#     # TTY 유지하면서 세션 기록 (파이프 없음)
#     set -l bin /home/utylee/.local/bin/llm
#     set -l cmd "env PYTHONUTF8=1 PYTHONIOENCODING=utf-8:replace $bin chat -m gpt-4o-mini -d $dbfile"

#     script -q -f -a $logfile -c "$cmd"
# end
# function gpt
#     set -l logdir /mnt/g2/llm_logs
#     set -l dbdir  $logdir/db
#     mkdir -p $dbdir

#     set -l name chat-(date "+%Y%m%d-%H%M%S")
#     set -l logfile $logdir/$name.log
#     set -l dbfile  $dbdir/$name.db

#     echo $name > $logdir/.last
#     echo "New conversation: $name"

#     llm chat -d $dbfile 2>&1 | tee -a $logfile
#     # llm chat -m gpt-4o-mini -d $dbfile 2>&1 | tee -a $logfile
# end
# function gpt
#     set -l logdir /mnt/g2/llm_logs
#     set -l dbdir  $logdir/db
#     mkdir -p $logdir $dbdir

#     # 이름 없으면 main
#     set -l name main
#     if test (count $argv) -ge 1
#         set name $argv[1]
#     end

#     set -l logfile $logdir/$name.log
#     set -l dbfile  $dbdir/$name.db

#     # last 기록
#     echo $name > $logdir/.last

#     echo "Conversation: $name"

#     # DB가 있으면 continue, 없으면 새로 시작
#     if test -f $dbfile
#         llm chat -d $dbfile -c 2>&1 | tee -a $logfile
#         # llm chat -m gpt-4o-mini -d $dbfile -c 2>&1 | tee -a $logfile
#     else
#         llm chat -d $dbfile 2>&1 | tee -a $logfile
#         # llm chat -m gpt-4o-mini -d $dbfile 2>&1 | tee -a $logfile
#     end
# end
# function gpt
#     set -l logdir /mnt/g2/llm_logs
#     set -l dbdir  $logdir/db
#     mkdir -p $dbdir

#     # 이름 없으면 main
#     set -l name main
#     if test (count $argv) -ge 1
#         set name $argv[1]
#     end

#     # 파일/DB 경로
#     set -l logfile $logdir/$name.log
#     set -l dbfile  $dbdir/$name.db

#     # last 기록
#     echo $name > $logdir/.last

#     # 핵심: 새 채팅은 그냥 chat, 이어붙이기는 -c (DB가 name별로 분리됨)
#     if test -f $dbfile
#         llm chat -c -d $dbfile 2>&1 | tee -a $logfile
#     else
#         llm chat -d $dbfile 2>&1 | tee -a $logfile
#     end
# end
# function gpt
#     set -l logdir /mnt/g2/llm_logs
#     mkdir -p $logdir

#     # 인자가 있으면 해당 이름으로 대화
#     if test (count $argv) -ge 1
#         set -l conv $argv[1]
#         echo $conv > $logdir/.last
#         echo "Conversation: $conv"
#         llm chat --conversation $conv | tee -a $logdir/$conv.log
#         return
#     end

#     # 기본: 새 채팅
#     set -l ts (date "+%Y%m%d-%H%M%S")
#     set -l conv "chat-$ts"
#     echo $conv > $logdir/.last
#     echo "Conversation: $conv"
#     llm chat --conversation $conv | tee -a $logdir/$conv.log
# end
# function gpt
#     set -l logdir /mnt/g2/llm_logs
#     mkdir -p $logdir

#     # 인자가 있으면 그 이름으로 대화 시작/이어가기
#     if test (count $argv) -ge 1
#         set -l conv $argv[1]
#         llm chat --conversation $conv | tee -a $logdir/$conv.log
#         return
#     end

#     # 기본은 항상 새 채팅(웹의 "새 채팅" 느낌)
#     set -l ts (date "+%Y%m%d-%H%M%S")
#     set -l conv "chat-$ts"
#     echo "Conversation: $conv"
#     llm chat --conversation $conv | tee -a $logdir/$conv.log
# end
