#!/bin/sh
# create a new session. Note the -d flag, we do not want to attach just yet!
tmux new-session -s pelican -n 'myWindow' -d

# split the window *vertically* -
tmux split-window -t pelican:myWindow.0 -v
# split the window *horizontally* |
tmux split-window -t pelican:myWindow.0 -h
# split the window *horizontally* -
 tmux split-window -t pelican:myWindow.2 -h

# send 'tail -f /var/log/<enter>' to the first pane.
# for the <enter> key, we can use either C-m (linefeed) or C-j (newline)
tmux send-keys -t pelican:myWindow.0 'sudo tail -f /var/log/messages' C-j
tmux rename-pane -t 0 'Messages'
tmux send-keys -t pelican:myWindow.1 'sudo tail -f /var/log/secure' C-j
tmux rename-pane -t 1 'Secure'
tmux send-keys -t pelican:myWindow.2 'sudo tail -f /var/log/firewalld' C-j
tmux rename-pane -t 2 'Firewalld'

# uncomment the following command if you want to attach
# explicitly to the window we just created

#tmux select-window -t pelican:mywindow

# finally attach to the session
tmux attach -t node00