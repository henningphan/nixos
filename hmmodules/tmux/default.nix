{ pkgs, ... }:
{
  home.packages = with pkgs; [ tmux ];
  home.file = {
    ".tmux.conf".source = ./tmux.conf;
    ".tmux.d/tmux.copy".source = ./tmux.copy;
    ".tmux.d/tmux.defaults.bindings".source = ./tmux.defaults.bindings;
    ".tmux.d/tmux.defaults.globals".source = ./tmux.defaults.globals;
    ".tmux.d/tmux.defaults.sessions".source = ./tmux.defaults.sessions;
    ".tmux.d/tmux.plugins".source = ./tmux.plugins;
    ".tmux.d/tmux.profile".source = ./tmux.profile;
    ".tmux.d/tmux.local".source = ./tmux.local;
  };
}
