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


function __lms_list_identifiers --description "List available LLM identifiers with size (cached)"
    set -l cache_dir ~/.cache
    set -l cache_file ~/.cache/lms_ls_llm_with_size.txt

    if not test -d $cache_dir
        mkdir -p $cache_dir 2>/dev/null
    end

    # 30초 캐시
    if test -f $cache_file
        set -l now (date +%s)
        set -l mtime (stat -c %Y $cache_file 2>/dev/null; or stat -f %m $cache_file 2>/dev/null)
        if test -n "$mtime"
            if test (math "$now - $mtime") -lt 30
                cat $cache_file
                return
            end
        end
    end

    set -l out (timeout 2s lms ls 2>/dev/null; or lms ls 2>/dev/null)
    set -l lines (string split \n -- $out)

    set -l in_llm 0

    for line in $lines
        if string match -qr '^LLM\s+PARAMS\s+ARCH\s+SIZE' -- $line
            set in_llm 1
            continue
        end

        if test $in_llm -eq 1; and string match -qr '^EMBEDDING\s+' -- $line
            break
        end

        if test $in_llm -ne 1
            continue
        end

        set -l t (string trim -- $line)
        if test -z "$t"
            continue
        end

        # 공백 정규화 후 split
        set -l toks (string split -n ' ' -- (string replace -ar '\s+' ' ' -- $t))
        set -l n (count $toks)
        if test $n -lt 5
            continue
        end

        # size = 마지막 2토큰
        set -l i1 (math "$n - 1")
        set -l size "$toks[$i1] $toks[$n]"

        # name(표시 문자열) = 앞부분 (끝에서 4토큰 제외)
        set -l name_end (math "$n - 4")
        if test $name_end -lt 1
            continue
        end
        set -l name (string join ' ' -- $toks[1..$name_end])

        # variants 표시 추출
        set -l variants (string match -r '\(\d+\s+variant[s]?\)' -- $name)

        # 실제 identifier(완성될 값) = variants 표시 제거
        set -l ident (string replace -r '\s*\(\d+\s+variant[s]?\)\s*$' '' -- $name)
        set -l ident (string trim -- $ident)

        # 오른쪽 설명
        set -l desc $size
        if test -n "$variants"
            set desc "$size · $variants"
        end

        printf "%s\t%s\n" $ident $desc
    end | sort -u > $cache_file

    cat $cache_file
end


# ---- base completions (필요한 것만 최소) ----
complete -c lms -f
complete -c lms -n '__fish_use_subcommand' -a 'ps ls load unload stop server status' -d 'LM Studio CLI'

# server subcommands
complete -c lms -n '__fish_seen_subcommand_from server; and __fish_use_subcommand' -a 'start stop' -d 'Start/stop LM Studio server'

# stop (= unload) argument completion
complete -c lms -n '__fish_seen_subcommand_from stop unload' -a '(__lms_loaded_identifiers)' -d 'Loaded model identifier'

complete -c lms -n '__fish_seen_subcommand_from load' -a '(__lms_list_identifiers)' -d 'Available model identifier'

