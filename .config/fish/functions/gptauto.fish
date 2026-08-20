function gptauto
    if test (count $argv) -lt 1
        echo "Usage: gptauto <conversation>"
        return 1
    end

    set -l conv $argv[1]

    # 요약 갱신
    gpts $conv

    # 기억 주입해서 시작
    gptmem $conv
end
