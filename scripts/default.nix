{
  pkgs,
  ...
}:
{
  w_next_sink = pkgs.writeScriptBin "w_next_sink" (builtins.readFile ./w_next_sink);
  repo-fzf = pkgs.writeShellApplication {
    name = "repo-fzf";
    text = builtins.readFile ./repo;
    runtimeInputs = [
      pkgs.fd
      pkgs.fzf
    ];

  };
}
