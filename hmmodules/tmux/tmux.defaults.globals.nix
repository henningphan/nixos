defaultShell: ''
  set -g activity-action other
  set -g assume-paste-time 1
  set -g base-index 0
  set -g bell-action any
  set -g default-command ""
  set -g default-shell ${defaultShell}
  set -g default-size 80x24
  set -g destroy-unattached off
  set -g detach-on-destroy on
  set -g display-panes-active-colour red
  set -g display-panes-colour blue
  set -g display-panes-time 1000
  set -g display-time 750
  set -g history-limit 2000
  set -g key-table root
  set -g lock-after-time 0
  set -g lock-command "lock -np"
  set -g message-command-style fg=yellow,bg=black
  set -g message-style fg=black,bg=yellow
  set -g mouse off
  set -g prefix C-b
  set -g prefix2 none
  set -g renumber-windows off
  set -g repeat-time 500
  set -g set-titles off
  set -g set-titles-string "#S:#I:#W - \"#T\" #{session_alerts}"
  set -g silence-action other
  set -g status on
  set -g status-bg green
  set -g status-fg black
  set -g status-format[0] "#[align=left range=left #{status-left-style}]#[push-default]#{T;=/#{status-left-length}:status-left}#[pop-default]#[norange default]#[list=on align=#{status-justify}]#[list=left-marker]<#[list=right-marker]>#[list=on]#{W:#[range=window|#{window_index} #{window-status-style}#{?#{&&:#{window_last_flag},#{!=:#{window-status-last-style},default}}, #{window-status-last-style},}#{?#{&&:#{window_bell_flag},#{!=:#{window-status-bell-style},default}}, #{window-status-bell-style},#{?#{&&:#{||:#{window_activity_flag},#{window_silence_flag}},#{!=:#{window-status-activity-style},default}}, #{window-status-activity-style},}}]#[push-default]#{T:window-status-format}#[pop-default]#[norange default]#{?window_end_flag,,#{window-status-separator}},#[range=window|#{window_index} list=focus #{?#{!=:#{window-status-current-style},default},#{window-status-current-style},#{window-status-style}}#{?#{&&:#{window_last_flag},#{!=:#{window-status-last-style},default}}, #{window-status-last-style},}#{?#{&&:#{window_bell_flag},#{!=:#{window-status-bell-style},default}}, #{window-status-bell-style},#{?#{&&:#{||:#{window_activity_flag},#{window_silence_flag}},#{!=:#{window-status-activity-style},default}}, #{window-status-activity-style},}}]#[push-default]#{T:window-status-current-format}#[pop-default]#[norange list=on default]#{?window_end_flag,,#{window-status-separator}}}#[nolist align=right range=right #{status-right-style}]#[push-default]#{T;=/#{status-right-length}:status-right}#[pop-default]#[norange default]"
  set -g status-format[1] "#[align=centre]#{P:#{?pane_active,#[reverse],}#{pane_index}[#{pane_width}x#{pane_height}]#[default] }"
  set -g status-interval 15
  set -g status-justify left
  set -g status-keys vi
  set -g status-left "[#S] "
  set -g status-left-length 10
  set -g status-left-style default
  set -g status-position bottom
  set -g status-right "#{?window_bigger,[#{window_offset_x}#,#{window_offset_y}] ,}\"#{=21:pane_title}\" %H:%M %d-%b-%y"
  set -g status-right-length 40
  set -g status-right-style default
  set -g status-style fg=black,bg=green
  set -g update-environment[0] DISPLAY
  set -g update-environment[1] KRB5CCNAME
  set -g update-environment[2] SSH_ASKPASS
  set -g update-environment[3] SSH_AUTH_SOCK
  set -g update-environment[4] SSH_AGENT_PID
  set -g update-environment[5] SSH_CONNECTION
  set -g update-environment[6] WINDOWID
  set -g update-environment[7] XAUTHORITY
  set -g visual-activity off
  set -g visual-bell off
  set -g visual-silence off
  set -g word-separators " "
''
