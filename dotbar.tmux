#!/usr/bin/env bash

get_tmux_option() {
  local option=$1
  local default_value="$2"
  local option_value
  option_value=$(tmux show-options -gqv "$option")
  if [ -n "$option_value" ]; then
    echo "$option_value"
    return
  fi
  echo "$default_value"
}

bg=$(get_tmux_option "@tmux-dotbar-bg" '#0B0E14')
fg=$(get_tmux_option "@tmux-dotbar-fg" '#475266')
fg_path=$(get_tmux_option "@tmux-dotbar-fg-path" '#f5a97f')
fg_prefix=$(get_tmux_option "@tmux-dotbar-fg-prefix" '#95E6CB')
fg_current=$(get_tmux_option "@tmux-dotbar-fg-current" '#BFBDB6')
fg_session=$(get_tmux_option "@tmux-dotbar-fg-session" '#565B66')

status=$(get_tmux_option "@tmux-dotbar-position" "bottom")
justify=$(get_tmux_option "@tmux-dotbar-justify" "absolute-centre")

left_state=$(get_tmux_option "@tmux-dotbar-left" "true")
if [ "$left_state" = "true" ]; then
  status_left="#{?client_prefix,#[bg=$fg_prefix]#[fg=$bg]#[bold] #S ,#[bg=$bg]#[fg=$fg_session] #S }"
else
  status_left=""
fi

right_state=$(get_tmux_option "@tmux-dotbar-right" "false")
if [ "$right_state" = "true" ]; then
  status_right="#[bg=$bg,fg=$fg_path] #{b:pane_current_path} #[bg=$bg,fg=$fg_session] %H:%M "
else
  status_right=""
fi

window_status_format=$(get_tmux_option "@tmux-dotbar-window-status-format" ' #W ')
window_status_separator=$(get_tmux_option "@tmux-dotbar-window-status-separator" ' • ')

maximized_pane_icon=$(get_tmux_option "@tmux-dotbar-maximized-icon" '󰊓')
show_maximized_icon_for_all_tabs=$(get_tmux_option "@tmux-dotbar-show-maximized-icon-for-all-tabs" "false")

tmux set-option -g status-position "$status"
tmux set-option -g status-style "bg=${bg},fg=${fg}"
tmux set-option -g status-justify "$justify"
tmux set-option -g status-left "$status_left"
tmux set-option -g status-right "$status_right"
tmux set-window-option -g window-status-separator "$window_status_separator"
tmux set-option -g window-status-style "bg=${bg},fg=${fg}"
tmux set-option -g window-status-format "$window_status_format"

if [ "$show_maximized_icon_for_all_tabs" = "true" ]; then
  tmux set-option -g window-status-format "${window_status_format}#{?window_zoomed_flag,${maximized_pane_icon},}"
fi

tmux set-option -g window-status-current-format "#[bg=${bg},fg=${fg_current}]${window_status_format}#[fg=#39BAE6,bg=${bg}]#{?window_zoomed_flag,${maximized_pane_icon},}#[fg=${bg},bg=default]"

if [[ "$(uname)" == "Darwin" ]]; then
  if [ "$right_state" = "true" ]; then
    status_right="#[bg=$bg,fg=$fg_path] #{b:pane_current_path} "
  else
    status_right=""
  fi
  tmux set-option -g status-right "$status_right"
fi
