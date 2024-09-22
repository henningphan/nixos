# Easy config reload
bind-key R source-file ~/.tmux.conf \; display-message "tmux.conf reloaded."

# misc
bind-key L clear-history

# switch panes
#bind-key -n "m-h" select-pane -t 0
#bind-key -n "m-t" select-pane -t 1
#bind-key -n "m-n" select-pane -t 2
#bind-key -n "m-s" select-pane -t 3

# switch pane on a mac
bind-key    -T prefix       h                    select-pane -t :.-
bind-key    -T prefix       n                    select-pane -t :.+

# switch windows
bind-key r next-window
bind-key g previous-window
bind-key -r m-n next-window
bind-key -r m-h previous-window

# create panes and windows
bind-key v split-window -h

bind-key c new-window -c "#{pane_current_path}"
