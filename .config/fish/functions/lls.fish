function lls
    if test "$LLS_REMOTE" = "1"
        # 기본: WSL2 sshd(8812)로 실행
        set -l host $LLS_REMOTE_SSH
        if test -z "$host"
            set host "utylee@localhost"
        end

        set -l port $LLS_REMOTE_PORT
        if test -z "$port"
            set port 8812
        end

        command ssh -p $port $host lls $argv
    else
        command /home/utylee/temp/bin/lls $argv
    end
end


# function lls
#     if test "$LLS_REMOTE" = "1"
#         # WSL2에서 실행 + 출력(로그 포함)을 그대로 WSL1에 스트리밍
#         command ssh $LLS_REMOTE_SSH lls $argv
#     else
#         command /home/utylee/temp/bin/lls $argv
#     end
# end

