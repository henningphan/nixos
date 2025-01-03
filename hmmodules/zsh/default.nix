{ pgks, ... }:
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.atuin = {
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
      gag = "gau && amende && git review";
      gau = "git add -u ";
      gd = "git diff";
      gl =  "git log --name-only";
      gs = "git status";
    };
    initExtra = ''
      startcisco(){
        cd ~/repo/openconnect-sso/ || exit 1
          ./result/bin/openconnect-sso -p VolvoCars-Linux_Profile.xml
      }
      '';

    cdpath = [ "~/repo" ];
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
    };
  };
}
