#!/bin/bash
echo "$> ./tmuxdev.sh {session-name} {working directory} "
echo "example: ./tmuxdev.sh mysession /Users/blah/dir "
echo "-----"
echo ""
echo ""

SESSION=$1
WORKDIR=$2

cd $WORKDIR
tmux -2 new-session -d -s $SESSION
# tmux attach-session -t $SESSION -c $WORKDIR

# create log window
tmux new-window -t $SESSION:2 -n 'log'
tmux split-window -v
tmux select-pane -t 0
tmux send-keys "tail -f runtime/logs/app.log" C-m
tmux select-pane -t 1
tmux resize-pane -D 5

# create worker window
tmux new-window -t $SESSION:3 -n 'worker'
tmux split-window -h
tmux select-pane -t 0
tmux send-keys "gulp" C-m
tmux select-pane -t 1
tmux send-keys "./yii serve"

#back to main window
tmux new-window -t $SESSION:1 -n 'main'
tmux attach-session -t $SESSION
