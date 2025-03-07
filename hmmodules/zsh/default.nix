{ pgks, ... }:
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    flags = [
      "--disable-up-arrow"
    ];
    settings = {
      enter_accept = false;
    };
  };

  programs.zsh = {
    enable = true;
    autosuggestion = {
      enable = true;
      highlight = "fg=#ff00ff,bg=cyan,bold,underline";
    };
    shellAliases = {
      amende = "git commit --amend --no-edit";
      amend = "git commit --amend";
      gag = "gau && amende && git review";
      gpr = "git pull --rebase";
      gau = "git add -u ";
      gd = "git diff";
      gl = "git log --name-status";
      gs = "git status";
      s = "sudo --preserve-env --preserve-env=PATH env";
    };
    initExtra = ''
      startcisco(){
        cd ~/repo/openconnect-sso/ || exit 1
          ./result/bin/openconnect-sso -p VolvoCars-Linux_Profile.xml --ac-version 5.1.6.103
      }
      eval "$(direnv hook zsh)"
      bindkey -M vicmd v edit-command-line
      bindkey -v
      unsetopt HIST_VERIFY
      [[ -f ~/.zsh.d/local ]] && . ~/.zsh.d/local
    '';

    cdpath = [ "~/repo" ];
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
    };
  };
}
