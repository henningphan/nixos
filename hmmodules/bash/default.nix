{ pgks, ... }:
{
  programs.bash = {
    enable = true;
    bashrcExtra = builtins.readFile ./bashrc;
  };
  home.file = {
    ".bash.d/repo-cempletion.bash".source = ./repo-completion.bash;
  };
}
