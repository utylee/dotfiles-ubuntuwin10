function lms --description "LM Studio CLI (Windows) wrapper for WSL2"
    # 'lms stop <id>' => 'lms unload <id>'
    set -l argv2 $argv
    if test (count $argv2) -ge 1; and test "$argv2[1]" = "stop"
        set argv2[1] "unload"
    end

    # PowerShell로 먼저 C:로 이동 후 lms 실행 (UNC 경고 방지)
    # -NoProfile: 프로필 출력/지연 방지
    # -NonInteractive: 비대화식
    # -ExecutionPolicy Bypass: 정책 때문에 막히는 경우 방지
    set -l args ""
    for a in $argv2
        # PowerShell 인자 안전하게 (따옴표 이스케이프)
        set a (string replace -a '"' '\"' -- $a)
        set args "$args \"$a\""
    end

    powershell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Set-Location C:\; & lms$args"
end



# function lms --description "LM Studio CLI (Windows) wrapper for WSL2" # 'lms stop <id>' 을 'lms unload <id>' 로 매핑
#     set -l argv2 $argv
#     if test (count $argv2) -ge 1; and test "$argv2[1]" = "stop"
#         set argv2[1] "unload"
#     end

#     # cmd.exe가 UNC를 CWD로 못 쓰니까, 윈도우 C:로 이동 후 실행
#     # /d: AutoRun 비활성화(원격쉘 잡출력 같은 거 줄이는데도 도움)
#     cmd.exe /d /c "cd /d C:\ && lms" $argv2
# end
# function lms
# 	cmd.exe /c "lms $argv"
# end
