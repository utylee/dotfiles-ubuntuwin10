function gtop --description "GPU monitor (nvidia-smi) without cursor bug"
    # 커서 숨김
    tput civis

    # 복구 함수(중복 실행되어도 문제 없음)
    function __gtop_restore_cursor --on-signal INT --on-signal TERM --on-event fish_exit
        tput cnorm
    end

    # 실행
    watch -n 1 --color nvidia-smi

    # 정상 종료(rare) 대비
    tput cnorm

    # 핸들러 정리(남겨도 큰 문제는 없지만 깔끔하게)
    functions -e __gtop_restore_cursor 2>/dev/null
end


# function gtop --description "GPU monitor (nvidia-smi) without cursor bug"
#     # 커서 숨김 방지/복구
#     tput civis

#     # Ctrl+C 등으로 종료될 때 커서 복구
#     function __restore_cursor --on-signal INT --on-signal TERM --on-signal EXIT
#         tput cnorm
#     end

#     watch -n 1 nvidia-smi

#     # 정상 종료 시도 대비
#     tput cnorm
# end
