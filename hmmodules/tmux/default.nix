{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.henning.tmux;
in
{
  options.henning.tmux = {
    enable = pkgs.lib.mkEnableOption "henning tmux";
    defaultShell = lib.mkOption {
      type = lib.types.str;
      default = "/run/current-system/sw/bin/bash";
    };

  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ tmux ];
    home.file = {
      ".tmux.conf".source = ./tmux.conf;
      ".tmux.d/tmux.copy".source = ./tmux.copy;
      ".tmux.d/tmux.defaults.bindings".source = ./tmux.defaults.bindings;
      ".tmux.d/tmux.defaults.globals".text = import ./tmux.defaults.globals.nix cfg.defaultShell;
      ".tmux.d/tmux.defaults.sessions".source = ./tmux.defaults.sessions;
      ".tmux.d/tmux.plugins".source = ./tmux.plugins;
      ".tmux.d/tmux.profile".source = ./tmux.profile;
      ".tmux.d/tmux.local".source = ./tmux.local;
    };
  };
}
