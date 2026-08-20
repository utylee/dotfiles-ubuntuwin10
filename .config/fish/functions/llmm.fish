function llm
    # llm 바이너리 실제 경로(재귀 호출 방지)
    set -l bin /home/utylee/.local/bin/llm

    # UTF-8 강제 + 깨진 바이트 들어와도 replace로 죽지 않게
    env PYTHONUTF8=1 PYTHONIOENCODING=utf-8:replace $bin $argv
end
# function llm
#     # fish에서는 env 뒤에 바로 실행 파일
#     env PYTHONUTF8=1 PYTHONIOENCODING=utf-8:replace /home/utylee/.local/bin/llm $argv
# end
# function llm
#     # UTF-8 강제 + 디코딩 에러 나도 죽지 않게(replace)
#     env PYTHONUTF8=1 PYTHONIOENCODING=utf-8:replace command llm $argv
# end
# function llm
#     env PYTHONUTF8=1 PYTHONIOENCODING=UTF-8 command llm $argv
# end
