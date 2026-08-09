# ---- helpers ----

function __lms_loaded_identifiers --description "List loaded model identifiers for completion"
    lms ps --json 2>/dev/null | python3 -c '
import sys, json

try:
    data = json.load(sys.stdin)
except Exception:
    sys.exit(0)

# JSON 구조가 버전별로 다를 수 있어, "identifier" 키만 정확히 찾아서 수집
out = set()

def walk(x):
    if isinstance(x, dict):
        for k, v in x.items():
            lk = k.lower()
            if lk == "identifier" and isinstance(v, str) and v.strip():
                out.add(v.strip())
            else:
                walk(v)
    elif isinstance(x, list):
        for i in x:
            walk(i)

walk(data)

for v in sorted(out):
    print(v)
'
end


function __lms_list_identifiers --description "List available model identifiers for completion (cached)"
    set -l cache_dir ~/.cache
    set -l cache_file ~/.cache/lms_ls_identifiers.txt

    # 캐시 파일이 없으면 만들기
    if not test -d $cache_dir
        mkdir -p $cache_dir 2>/dev/null
    end

    # 캐시가 30초 이내면 그대로 사용 (탭칠 때마다 느려지는 거 방지)
    if test -f $cache_file
        set -l now (date +%s)
        set -l mtime (stat -c %Y $cache_file 2>/dev/null; or stat -f %m $cache_file 2>/dev/null)
        if test -n "$mtime"
            if test (math $now - $mtime) -lt 30
                cat $cache_file
                return
            end
        end
    end

    # (중요) 느리면 탭이 깜빡만 하니까 timeout을 걸고,
    # JSON 대신 표 출력에서 첫 컬럼(identifier)만 뽑는다.
    # GNU timeout이 없으면 그냥 실행되게 fallback.
    set -l out (timeout 2s lms ls 2>/dev/null; or lms ls 2>/dev/null)

    # 표에서 identifier만 추출:
    # - 헤더 줄/구분선 제거
    # - 첫 컬럼만
    # - 빈 줄 제거

	set -l ids (string split \n -- $out \
    | string match -rv '^(IDENTIFIER|MODEL|STATUS|SIZE|CONTEXT|TTL)\b' \
    | string match -rv '^(EMBEDDING|You|LLM)\b' \
    | string match -rv '^\s*$' \
    | awk '{print $1}' \
    | sort -u)

    # set -l ids (string split \n -- $out \
    #     | string match -rv '^(IDENTIFIER|MODEL|STATUS|SIZE|CONTEXT|TTL)\b' \
    #     | string match -rv '^\s*$' \
    #     | awk '{print $1}' \
    #     | sort -u)

    # 캐시 저장
    if test (count $ids) -gt 0
        printf "%s\n" $ids > $cache_file
        printf "%s\n" $ids
    end
end

# function __lms_list_identifiers --description "List available model identifiers for completion"
#     lms ls --json 2>/dev/null | python3 -c '
# import sys, json
# try:
#     data = json.load(sys.stdin)
# except Exception:
#     sys.exit(0)

# out = set()

# def walk(x):
#     if isinstance(x, dict):
#         for k, v in x.items():
#             lk = k.lower()
#             # ls 결과에서 "identifier"만 정확히 수집
#             if lk == "identifier" and isinstance(v, str) and v.strip():
#                 out.add(v.strip())
#             else:
#                 walk(v)
#     elif isinstance(x, list):
#         for i in x:
#             walk(i)

# walk(data)

# for v in sorted(out):
#     print(v)
# '
# end


# ---- base completions (필요한 것만 최소) ----
complete -c lms -f
complete -c lms -n '__fish_use_subcommand' -a 'ps ls load unload stop server status' -d 'LM Studio CLI'

# server subcommands
complete -c lms -n '__fish_seen_subcommand_from server; and __fish_use_subcommand' -a 'start stop' -d 'Start/stop LM Studio server'

# stop (= unload) argument completion
complete -c lms -n '__fish_seen_subcommand_from stop unload' -a '(__lms_loaded_identifiers)' -d 'Loaded model identifier'

complete -c lms -n '__fish_seen_subcommand_from load' -a '(__lms_list_identifiers)' -d 'Available model identifier'

