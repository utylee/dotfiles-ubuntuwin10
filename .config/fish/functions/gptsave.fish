function gptsave
    # --- parse flags safely ---
    set -l auto 0
    set -l force 0

    set -l args $argv
    set -l rest
    for a in $args
        switch $a
            case --auto
                set auto 1
            case --force
                set force 1
            case '*'
                set -a rest $a
        end
    end
    set argv $rest

    set -l logroot /mnt/g2/llm_logs
    set -l metadir $logroot/.meta
    set -l localdb ~/.cache/llm/db
    set -l nasdb   $logroot/db
    mkdir -p $metadir $localdb $nasdb

    # target name: arg or .last
    set -l name ""
    if test (count $argv) -ge 1
        set name $argv[1]
    else
        if not test -f $logroot/.last
            echo "No last conversation."
            return 1
        end
        set name (string trim (cat $logroot/.last))
    end

    if test -z "$name"
        echo "Empty conversation name."
        return 1
    end

    set -l logfile $logroot/$name.log
    set -l localdbfile $localdb/$name.db
    set -l nasdbfile   $nasdb/$name.db

    if not test -f $logfile
        echo "Log not found: $logfile"
        return 1
    end
    if not test -f $localdbfile
        echo "Local DB not found: $localdbfile"
        return 1
    end

    # temp name?
    set -l is_temp 0
    if string match -qr '^chat-[0-9]{8}-[0-9]{6}$' -- $name
        set is_temp 1
    end

    # if not temp and not force → nothing to do
    if test $is_temp -eq 0; and test $force -eq 0
        if test $auto -eq 0
            echo "Not a temp name. Use: gptsave --force $name"
        end
        return 0
    end

    # extract stamp (always from end)
    set -l stamp (string match -r '[0-9]{8}-[0-9]{6}$' -- $name)
    if test -z "$stamp"
        # fallback: if somehow missing, use current time
        set stamp (date "+%Y%m%d-%H%M%S")
    end

    # build excerpt (keep it modest for cost)
    set -l excerpt (tail -n 220 $logfile | string collect)

    # title suggestion
    set -l genprompt "다음은 터미널에서 진행한 대화 로그 일부입니다. 이 대화의 주제를 가장 잘 나타내는 짧은 제목을 한국어로 8~16자 정도로 1개만 제안해 주세요. 따옴표/마침표 없이 제목만 출력하세요.\n\n---\n$excerpt\n---\n\n제목:"
    # set -l title (llm -m gpt-4o-mini $genprompt | head -n 1 | string trim)
    set -l title (llm $genprompt | head -n 1 | string trim)
    if test -z "$title"
        set title "대화"
    end

    # slugify helper (inline)
    set -l slug $title
    set slug (string replace -ar '[[:space:]]+' '-' -- $slug)
    set slug (string replace -ar '[\\/:*?"<>|]' '' -- $slug)
    set slug (string replace -ar '^-+|-+$' '' -- $slug)
    if test (string length -- $slug) -gt 40
        set slug (string sub -l 40 -- $slug)
        set slug (string replace -ar '^-+|-+$' '' -- $slug)
    end
    if test -z "$slug"
        set slug "대화"
    end

    set -l newname "$slug-$stamp"

    # manual mode: allow override
    if test $auto -eq 0
        echo ""
        echo "Suggested title: $title"
        echo "Proposed id:     $newname"
        read -l -P "Enter to accept, or type a new title: " usertitle

        if test -n "$usertitle"
            set title $usertitle
            set slug $title
            set slug (string replace -ar '[[:space:]]+' '-' -- $slug)
            set slug (string replace -ar '[\\/:*?"<>|]' '' -- $slug)
            set slug (string replace -ar '^-+|-+$' '' -- $slug)
            if test (string length -- $slug) -gt 40
                set slug (string sub -l 40 -- $slug)
                set slug (string replace -ar '^-+|-+$' '' -- $slug)
            end
            if test -z "$slug"
                set slug "대화"
            end
            set newname "$slug-$stamp"
        end
    end

    # avoid collisions
    set -l cand $newname
    set -l i 2
    while test -f $logroot/$cand.log -o -f $localdb/$cand.db
        set cand "$newname-$i"
        set i (math $i + 1)
    end
    set newname $cand

    # rename log + local db
    mv -n $logfile $logroot/$newname.log
    mv -n $localdbfile $localdb/$newname.db

    # rename nas db if present (best-effort)
    if test -f $nasdbfile
        mv -n $nasdbfile $nasdb/$newname.db 2>/dev/null
    end

    echo $newname > $logroot/.last

    # meta record
    set -l now (date "+%Y-%m-%d %H:%M:%S")
    printf "%s\t%s\t%s\t%s\n" $name $newname $title $now >> $metadir/renames.tsv

    if test $auto -eq 0
        echo "Saved as: $newname"
    end
end
# function gptsave
# 	set -l force 0
# 	if test (count $argv) -ge 1; and test "$argv[1]" = "--force"
# 		set force 1
# 		set -e argv[1]
# 	end

#     set -l logroot /mnt/g2/llm_logs
#     set -l metadir $logroot/.meta
#     set -l localdb ~/.cache/llm/db
#     set -l nasdb   $logroot/db
#     mkdir -p $metadir $localdb $nasdb

#     # 대상 대화 이름: 인자 있으면 그거, 아니면 .last
#     set -l name ""
#     if test (count $argv) -ge 1
#         set name $argv[1]
#     else
#         if not test -f $logroot/.last
#             echo "No last conversation."
#             return 1
#         end
#         set name (string trim (cat $logroot/.last))
#     end

#     if test -z "$name"
#         echo "Empty conversation name."
#         return 1
#     end

#     set -l logfile $logroot/$name.log
#     set -l localdbfile $localdb/$name.db
#     set -l nasdbfile   $nasdb/$name.db

#     if not test -f $logfile
#         echo "Log not found: $logfile"
#         return 1
#     end
#     if not test -f $localdbfile
#         echo "Local DB not found: $localdbfile"
#         return 1
#     end

# 	set -l is_temp 0
# 	if string match -qr '^chat-[0-9]{8}-[0-9]{6}$' -- $name
# 		set is_temp 1
# 	end

# 	# 임시이름이 아닌데 force도 아니면 종료
# 	if test $is_temp -eq 0; and test $force -eq 0
# 		echo "Not a temp name. Use: gptsave --force $name"
# 		return 0
# 	end

#     # # 이미 저장(리네임)한 적 있는지 판단: 임시이름(chat-...)이면 아직, 아니면 이미
#     # if not string match -qr '^chat-[0-9]{8}-[0-9]{6}$' -- $name
#     #     echo "Already looks saved (not a temp name): $name"
#     #     return 0
#     # end

#     # 로그에서 최근 일부만 추출해서 제목 생성 (비용/토큰 절약)
#     set -l excerpt (tail -n 220 $logfile | string collect)
#     set -l genprompt "다음은 터미널에서 진행한 대화 로그 일부입니다. 이 대화의 주제를 가장 잘 나타내는 짧은 제목을 한국어로 8~16자 정도로 1개만 제안해 주세요. 따옴표/마침표 없이 제목만 출력하세요.\n\n---\n$excerpt\n---\n\n제목:"
#     set -l title (llm -m gpt-4o-mini $genprompt | head -n 1 | string trim)

#     # 타이틀이 비었으면 fallback
#     if test -z "$title"
#         set title "대화"
#     end

#     # 파일명 안전하게 만들기(공백->-, 금지문자 제거, 길이 제한)
#     set -l slug $title
#     set slug (string replace -ar '[[:space:]]+' '-' -- $slug)
#     set slug (string replace -ar '[\\/:*?"<>|]' '' -- $slug)
#     set slug (string replace -ar '^-+|-+$' '' -- $slug)
#     if test (string length -- $slug) -gt 40
#         set slug (string sub -l 40 -- $slug)
#         set slug (string replace -ar '^-+|-+$' '' -- $slug)
#     end
#     if test -z "$slug"
#         set slug "대화"
#     end

#     # 원래 타임스탬프 붙여 충돌 방지
#     # set -l stamp (string replace -r '^chat-' '' -- $name)
# 	# 파일명 끝의 YYYYMMDD-HHMMSS 만 추출
# 	set -l stamp (string match -r '[0-9]{8}-[0-9]{6}$' -- $name)

#     set -l newname "$slug-$stamp"

#     echo ""
#     echo "Suggested title: $title"
#     echo "Proposed id:     $newname"
#     echo -n "Enter to accept, or type a new title: "
#     read -l usertitle

#     if test -n "$usertitle"
#         set title $usertitle
#         set slug $title
#         set slug (string replace -ar '[[:space:]]+' '-' -- $slug)
#         set slug (string replace -ar '[\\/:*?"<>|]' '' -- $slug)
#         set slug (string replace -ar '^-+|-+$' '' -- $slug)
#         if test (string length -- $slug) -gt 40
#             set slug (string sub -l 40 -- $slug)
#             set slug (string replace -ar '^-+|-+$' '' -- $slug)
#         end
#         if test -z "$slug"
#             set slug "대화"
#         end
#         set newname "$slug-$stamp"
#     end

#     # 충돌 방지: 이미 있으면 뒤에 -2, -3 붙임
#     set -l cand $newname
#     set -l i 2
#     while test -f $logroot/$cand.log -o -f $localdb/$cand.db
#         set cand "$newname-$i"
#         set i (math $i + 1)
#     end
#     set newname $cand

#     # rename 수행 (log + local db + nas db(있으면))
#     mv -n $logfile $logroot/$newname.log
#     mv -n $localdbfile $localdb/$newname.db
#     if test -f $nasdbfile
#         mv -n $nasdbfile $nasdb/$newname.db
#     end

#     echo $newname > $logroot/.last

#     # 메타 기록(한 줄): old \t new \t title \t time
#     set -l now (date "+%Y-%m-%d %H:%M:%S")
#     printf "%s\t%s\t%s\t%s\n" $name $newname $title $now >> $metadir/renames.tsv

#     echo "Saved as: $newname"
# end
# function gptsave
#     set -l logdir /mnt/g2/llm_logs
#     set -l dbdir  $logdir/db
#     set -l lastfile $logdir/.last

#     if not test -f $lastfile
#         echo "No last conversation found."
#         return 1
#     end

#     set -l old (string trim (cat $lastfile))
#     if test -z "$old"
#         echo "Last conversation is empty."
#         return 1
#     end

#     set -l oldlog $logdir/$old.log
#     set -l olddb  $dbdir/$old.db

#     if not test -f $oldlog
#         echo "Log not found: $oldlog"
#         return 1
#     end

#     # 1) 제목 후보 생성 (짧고 파일명 안전)
#     set -l suggestion (llm -m gpt-4o-mini -s "
# 아래 대화 로그를 읽고 '파일명용 제목' 하나를 만들어라.

# 규칙:
# - 한국어 중심(필요시 영문/숫자 가능)
# - 핵심 주제만
# - 3~7 단어 이내
# - 공백은 하이픈(-)으로
# - 특수문자 금지
# - 출력은 제목 한 줄만
# " < $oldlog)

#     set suggestion (string trim $suggestion)

#     # 공백 -> 하이픈
#     set suggestion (string replace -ra '\s+' '-' $suggestion)
#     # 허용 문자만 남기기 (한글/영문/숫자/하이픈)
#     set suggestion (string replace -ra '[^가-힣A-Za-z0-9\-]' '' $suggestion)
#     # 하이픈 정리
#     set suggestion (string replace -ra '\-+' '-' $suggestion)
#     set suggestion (string trim -c '-' $suggestion)

#     if test -z "$suggestion"
#         echo "Failed to generate title suggestion."
#         return 1
#     end

#     echo ""
#     echo "Suggested title:"
#     echo "  $suggestion"
#     echo ""

#     # 2) 사용자 확인/수정 받기 (엔터=수락)
#     read -P "Enter new title (or press Enter to accept)> " newtitle
#     if test -z "$newtitle"
#         set newtitle $suggestion
#     end

#     # 사용자 입력도 동일 규칙으로 정리
#     set newtitle (string trim $newtitle)
#     set newtitle (string replace -ra '\s+' '-' $newtitle)
#     set newtitle (string replace -ra '[^가-힣A-Za-z0-9\-]' '' $newtitle)
#     set newtitle (string replace -ra '\-+' '-' $newtitle)
#     set newtitle (string trim -c '-' $newtitle)

#     if test -z "$newtitle"
#         echo "Title became empty after sanitizing. Aborting."
#         return 1
#     end

#     # 같으면 rename 생략
#     if test "$newtitle" = "$old"
#         echo "Title unchanged: $old"
#         # 요약만 생성
#         gpts $old
#         return $status
#     end

#     # 충돌 체크
#     set -l newlog $logdir/$newtitle.log
#     set -l newdb  $dbdir/$newtitle.db
#     if test -f $newlog; or test -f $newdb
#         echo "Target already exists: $newtitle"
#         return 1
#     end

#     # 3) rename 수행 (log/db/mem)
#     set -l oldmem $logdir/$old.mem.md
#     set -l newmem $logdir/$newtitle.mem.md

#     mv $oldlog $newlog
#     if test -f $olddb
#         mv $olddb $newdb
#     end
#     if test -f $oldmem
#         mv $oldmem $newmem
#     end

#     echo $newtitle > $lastfile

#     echo ""
#     echo "Renamed:"
#     echo "  $old  →  $newtitle"
#     echo ""

#     # 4) 요약 생성
#     gpts $newtitle

#     echo ""
#     echo "Done."
#     echo "  Log : $newlog"
#     echo "  DB  : $newdb"
#     echo "  Mem : $newmem"
# end
