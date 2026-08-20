function gpts
    set -l logdir /mnt/g2/llm_logs
    set -l lastfile $logdir/.last

    set -l name ""
    if test (count $argv) -ge 1
        set name $argv[1]
    else if test -f $lastfile
        set name (string trim (cat $lastfile))
    end

    if test -z "$name"
        echo "Usage: gpts <name>  (or run after a conversation)"
        return 1
    end

    set -l logfile $logdir/$name.log
    set -l memfile $logdir/$name.mem.md

    if not test -f $logfile
        echo "Log not found: $logfile"
        return 1
    end

    # 요약은 mini로 (싸고 충분)
    # set -l summary (llm -m gpt-4o-mini -s "
    set -l summary (llm -s "
아래는 사용자와 AI의 대화 로그다. 다음 형식으로 한국어 요약을 작성하라.

형식:
- 제목: (한 줄)
- 목적: (1~2줄)
- 핵심 결정/결론: (불릿 3~8개)
- 중요한 사실/설정/제약: (불릿)
- 다음 행동(TO DO): (불릿)
- 참고 명령/코드 조각: (필요시만)

주의:
- 과도한 장황함 금지
- 실행에 도움 되는 정보 위주
" < $logfile)

    printf "%s\n" $summary > $memfile
    echo "Wrote: $memfile"
end

# function gpts
#     if test (count $argv) -eq 0
#         echo "Usage: gpts <conversation>"
#         return 1
#     end

#     set -l name $argv[1]
#     set -l dir /mnt/nas/chatgpt
#     set -l log $dir/$name.log
#     set -l mem $dir/$name.mem.md

#     if not test -f $log
#         echo "Log not found: $log"
#         return 1
#     end

#     llm -s "
# 너는 대화 기록을 '기억 카드'로 정리하는 비서다.
# 아래 로그를 읽고 요약을 만들어라.

# 형식:
# - 주제/사건 개요
# - 핵심 인물/대상 (고유명사 유지)
# - 중요 사실관계 / 결정사항
# - 현재 상태
# - 미해결 쟁점
# - 다음 액션 (체크리스트)
# - 주의사항 (잊으면 안 되는 것 3개)

# 조건:
# - 한국어
# - 30~60줄 이내
# - 추측 금지, 로그에 없는 내용 추가 금지
# - 나중에 system 프롬프트로 쓰일 것임
# " < $log > $mem

#     echo "Summary written to $mem"
# end
