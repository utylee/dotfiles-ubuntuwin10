function lls --description "WSL2 llama-server manager (remote via ssh host: wsl2)"
    command ssh wsl12 lls $argv
end

# function __ll__ssh_call --description "internal: ssh <host> lls <args...>"
#     set -l host $argv[1]
#     set -e argv[1]
#     command ssh $host lls $argv
# end

# function lls --description "WSL2 llama-server manager (remote)"
#     __ll__ssh_call wsl12 $argv
# end

# function llm --description "Mac (Metal) llama-server manager (remote)"
#     __ll__ssh_call mac $argv
# end

# function llh --description "Halo (high-mem) llama-server manager (remote, supports --slot)"
#     set -l base 8080
#     if set -q LLS_HALO_BASE_PORT
#         set base $LLS_HALO_BASE_PORT
#     end

#     set -l out
#     set -l i 1
#     while test $i -le (count $argv)
#         set -l a $argv[$i]
#         if test "$a" = "--slot"
#             set -l s $argv[(math $i + 1)]
#             set -l p (math $base + $s)
#             set out $out --port $p
#             set i (math $i + 2)
#             continue
#         end
#         set out $out $a
#         set i (math $i + 1)
#     end

#     __ll__ssh_call halo $out
# end



# # # WSL1 controller
# # # ssh config에 다음 host가 있다고 가정:
# # #   ssh wsl2
# # #   ssh mac
# # #   ssh halo   (미래)

# # function __ll__ssh_call --description "internal: ssh <host> lls <args...>"
# #     set -l host $argv[1]
# #     set -e argv[1]
# #     command ssh $host lls $argv
# # end

# # function lls --description "lls: WSL2 llama-server manager"
# #     __ll__ssh_call wsl12 $argv
# # end

# # function llm --description "llm: Mac (Metal) llama-server manager"
# #     __ll__ssh_call mac $argv
# # end

# # function llh --description "llh: Halo (high-mem) llama-server manager (supports --slot)"
# #     # --slot N => --port (base_port + N)
# #     set -l base 8080
# #     if set -q LLS_HALO_BASE_PORT
# #         set base $LLS_HALO_BASE_PORT
# #     end

# #     set -l out
# #     set -l i 1
# #     while test $i -le (count $argv)
# #         set -l a $argv[$i]

# #         if test "$a" = "--slot"
# #             set -l s $argv[(math $i + 1)]
# #             set -l p (math $base + $s)
# #             set out $out --port $p
# #             set i (math $i + 2)
# #             continue
# #         end

# #         set out $out $a
# #         set i (math $i + 1)
# #     end

# #     __ll__ssh_call halo $out
# # end




# # function lls
# #     if test "$LLS_REMOTE" = "1"
# #         # 기본: WSL2 sshd(8812)로 실행
# #         set -l host $LLS_REMOTE_SSH
# #         if test -z "$host"
# #             set host "utylee@localhost"
# #         end

# #         set -l port $LLS_REMOTE_PORT
# #         if test -z "$port"
# #             set port 8812
# #         end

# #         command ssh -p $port $host lls $argv
# #     else
# #         command /home/utylee/temp/bin/lls $argv
# #     end
# # end


# # function lls
# #     if test "$LLS_REMOTE" = "1"
# #         # WSL2에서 실행 + 출력(로그 포함)을 그대로 WSL1에 스트리밍
# #         command ssh $LLS_REMOTE_SSH lls $argv
# #     else
# #         command /home/utylee/temp/bin/lls $argv
# #     end
# # end

