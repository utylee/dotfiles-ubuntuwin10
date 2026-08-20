function gptm
    set -l logdir /mnt/g2/llm_logs
    mkdir -p $logdir

    set -l conv main
    echo $conv > $logdir/.last
    echo "Conversation: $conv"
    llm chat --conversation $conv | tee -a $logdir/$conv.log
end
# function gptm
#     set -l logdir /mnt/g2/llm_logs
#     mkdir -p $logdir

#     set -l conv main
#     llm chat --conversation $conv | tee -a $logdir/$conv.log
# end
