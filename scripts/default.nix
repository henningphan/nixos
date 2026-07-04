{
  pkgs,
  ...
}:
{
  w_next_sink = pkgs.writeScriptBin "w_next_sink" (builtins.readFile ./w_next_sink);
}
