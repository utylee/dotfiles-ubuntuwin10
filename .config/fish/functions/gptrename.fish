function gptrename
    if not type -q fzf
        echo "Install fzf: sudo apt install fzf"
        return 1
    end

    # 목록: 로그 기준으로 보여줌 (gptls 사용)
    set -l names (gptls)
    if test (count $names) -eq 0
        echo "No conversations."
        return 1
    end

    set -l choice (printf "%s\n" $names | fzf --prompt="Rename which conversation?> ")
    test -z "$choice"; and return 1

    # 선택한 대화의 DB가 로컬에 없으면 NAS에서 자동 pull 시도
    set -l localdb ~/.cache/llm/db
    set -l logroot /mnt/g2/llm_logs
    set -l nasdb $logroot/db

    if not test -f $localdb/$choice.db
        if test -f $nasdb/$choice.db
            gptpull $choice >/dev/null 2>&1
        end
    end

    # 수동 모드(rename 프롬프트 뜸). temp가 아니어도 rename 가능하게 force
    gptsave --force $choice
end
# function gptrename
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
#     set -l oldmem $logdir/$old.mem.md

#     if not test -f $oldlog
#         echo "Log not found: $oldlog"
#         return 1
#     end

#     # 제목 생성: 파일명 안전한 한글/영문/숫자/하이픈
#     set -l title (llm -m gpt-4o-mini -s "
# 아래 대화 로그를 읽고 '파일명용 제목' 하나를 만들어라.

# 규칙:
# - 한국어 중심(필요하면 영문 섞여도 됨)
# - 핵심 주제만
# - 3~7 단어 이내
# - 조사/불필요한 수식어 제거
# - 파일명에 안전하도록 공백은 하이픈(-)으로
# - 특수문자 사용 금지
# - 출력은 제목 한 줄만
# " < $oldlog)

#     set title (string trim $title)

#     # 공백 -> 하이픈
#     set title (string replace -ra '\s+' '-' $title)
#     # 허용 문자만 남기기 (한글/영문/숫자/하이픈)
#     set title (string replace -ra '[^가-힣A-Za-z0-9\-]' '' $title)
#     # 하이픈 정리
#     set title (string replace -ra '\-+' '-' $title)
#     set title (string trim -c '-' $title)

#     if test -z "$title"
#         echo "Failed to generate title."
#         return 1
#     end

#     set -l new $title
#     set -l newlog $logdir/$new.log
#     set -l newdb  $dbdir/$new.db
#     set -l newmem $logdir/$new.mem.md

#     if test -f $newlog; or test -f $newdb
#         echo "Target already exists: $new"
#         return 1
#     end

#     mv $oldlog $newlog

#     if test -f $olddb
#         mv $olddb $newdb
#     end

#     if test -f $oldmem
#         mv $oldmem $newmem
#     end

#     echo $new > $lastfile

#     echo "Renamed:"
#     echo "  $old  →  $new"
# end
