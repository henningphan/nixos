{ pkgs, ... }:
let
  macdotatoggle = pkgs.writeShellScriptBin "macdotatoggle" (builtins.readFile ./macdotatoggle);
in
{
  home.packages = [ macdotatoggle ];
}
