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



# ---- helpers ----
# function __lms_loaded_identifiers --description "List loaded model identifiers for completion"
#     # lms ps --json 이 공식 지원됨
#     # JSON 파싱은 python3로 (jq 없어도 됨)
#     lms ps --json 2>/dev/null | python3 -c '
# import sys, json
# try:
#     data = json.load(sys.stdin)
# except Exception:
#     sys.exit(0)

# # 문서 예시상 Identifier가 출력되며, JSON도 loaded models 리스트를 준다.
# # 실제 키 구조는 버전에 따라 다를 수 있어서 최대한 관대하게 처리.
# def walk(x):
#     if isinstance(x, dict):
#         for k, v in x.items():
#             if k.lower() in ("identifier","id","name") and isinstance(v, str):
#                 print(v)
#             else:
#                 walk(v)
#     elif isinstance(x, list):
#         for i in x: walk(i)

# walk(data)
# ' | sort -u
# end

# ---- base completions (필요한 것만 최소) ----
complete -c lms -f
complete -c lms -n '__fish_use_subcommand' -a 'ps ls load unload stop server status' -d 'LM Studio CLI'

# server subcommands
complete -c lms -n '__fish_seen_subcommand_from server; and __fish_use_subcommand' -a 'start stop' -d 'Start/stop LM Studio server'

# stop (= unload) argument completion
complete -c lms -n '__fish_seen_subcommand_from stop unload' -a '(__lms_loaded_identifiers)' -d 'Loaded model identifier'


