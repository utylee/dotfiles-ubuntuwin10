function lms --description "LM Studio CLI wrapper (cross-platform)"
    # stop → unload 별칭 유지
    set -l argv2 $argv
    # if test (count $argv2) -ge 1; and test "$argv2[1]" = "stop"
    #     set argv2[1] "unload"
    # end

	    # subcommand alias들
    if test (count $argv2) -ge 1
        switch $argv2[1]
            case stop
                set argv2[1] unload
            case list
                set argv2[1] ls
        end
    end

    switch (uname)
        case Linux
            # WSL / Linux
            if test -n "$WSL_DISTRO_NAME"
                # WSL: Windows lms 호출
                set -l args ""
                for a in $argv2
                    set a (string replace -a '"' '\"' -- $a)
                    set args "$args \"$a\""
                end
                powershell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass \
                    -Command "Set-Location C:\; & lms$args"
            else
                # 순수 Linux (lms가 PATH에 있으면)
                command lms $argv2
            end

        case Darwin
            # macOS
            command lms $argv2
    end
end
