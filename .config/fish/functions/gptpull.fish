function gptpull
    set -l logroot /mnt/g2/llm_logs
    set -l nasdb   $logroot/db
    set -l localdb ~/.cache/llm/db
    mkdir -p $localdb

    if test (count $argv) -lt 1
        echo "Usage: gptpull <name>"
        return 1
    end

    set -l name $argv[1]
    set -l src $nasdb/$name.db
    set -l dst $localdb/$name.db

    if not test -f $src
        echo "NAS DB not found: $src"
        return 1
    end

    rsync -a $src $dst
    echo "Pulled DB to local: $dst"
end
