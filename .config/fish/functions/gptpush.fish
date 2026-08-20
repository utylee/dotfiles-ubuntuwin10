function gptpush
    set -l logroot /mnt/g2/llm_logs
    set -l localdb ~/.cache/llm/db
    set -l nasdb   $logroot/db
    mkdir -p $nasdb

    if not test -f $logroot/.last
        echo "No last conversation."
        return 1
    end

    set -l name (string trim (cat $logroot/.last))
    set -l src $localdb/$name.db
    set -l dst $nasdb/$name.db

    if not test -f $src
        echo "Local DB not found: $src"
        return 1
    end

    # rsync -a --inplace $src $dst
	# rsync -rlt --inplace --no-perms --no-owner --no-group $src $dst
	rsync -rl --inplace --no-perms --no-owner --no-group --no-times $src $dst
end
# function gptpush
#     set -l logroot /mnt/g2/llm_logs
#     set -l nasdb   $logroot/db
#     set -l localdb ~/.cache/llm/db
#     set -l lastfile $logroot/.last
#     mkdir -p $nasdb

#     if not test -f $lastfile
#         echo "No last conversation."
#         return 1
#     end

#     set -l name (string trim (cat $lastfile))
#     set -l src $localdb/$name.db
#     set -l dst $nasdb/$name.db

#     if not test -f $src
#         echo "Local DB not found: $src"
#         return 1
#     end

#     rsync -a --inplace $src $dst
#     echo "Auto-pushed DB to NAS: $dst"
# end
# function gptpush
#     set -l logroot /mnt/g2/llm_logs
#     set -l nasdb   $logroot/db
#     set -l localdb ~/.cache/llm/db
#     set -l lastfile $logroot/.last
#     mkdir -p $nasdb

#     if not test -f $lastfile
#         echo "No last conversation."
#         return 1
#     end

#     set -l name (string trim (cat $lastfile))
#     set -l src $localdb/$name.db
#     set -l dst $nasdb/$name.db

#     if not test -f $src
#         echo "Local DB not found: $src"
#         return 1
#     end

#     rsync -a --inplace $src $dst
#     echo "Pushed DB to NAS: $dst"
# end
