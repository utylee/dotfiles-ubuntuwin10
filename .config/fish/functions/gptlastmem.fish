function gptlastmem
    set -l logdir /mnt/g2/llm_logs
    set -l lastfile $logdir/.last

    if not test -f $lastfile
        echo "No last conversation found."
        return 1
    end

    set -l conv (cat $lastfile)
    gptmem $conv
end
