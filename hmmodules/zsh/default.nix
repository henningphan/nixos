{ pgks, ... }:
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    autosuggestion = {
      enable = true;
      highlight = "fg=#ff00ff,bg=cyan,bold,underline";
    };
    shellAliases = {
      amend = "git commit --amend";
    };
    cdpath = [ "~/repo" ];
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
    };
  };
}
