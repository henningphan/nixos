{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.neovim;
in
{
  options.programs.neovim.extraPlugins = lib.mkOption {
    default = with pkgs.vimPlugins; [ ];
    description = lib.mdDoc ''
      add extra plugins
    '';
  };

  config = {
    home.file = {
      "${config.xdg.configHome}/nvim" = {
        source = ./nvim;
        recursive = true;
      };
    };

    programs.neovim = {
      defaultEditor = true;
      enable = true;
      vimAlias = true;
      extraLuaConfig =
        let
          luaFiles =
            let
              luaDir = builtins.readDir ./nvim/lua;
              onlyFiles = (n: v: v == "regular");
            in
            builtins.attrNames (lib.attrsets.filterAttrs onlyFiles luaDir);
          mkRequire = (
            path:
            let
              filePath = toString path;
              requireName = lib.strings.removeSuffix ''.lua'' filePath;
            in
            "require'${requireName}'"
          );
        in
        lib.strings.concatMapStrings (s: s + "\n") (map mkRequire luaFiles);

      extraPackages = with pkgs; [
        go-tools
        gopls
        lua-language-server
        marksman
        nil
        nodePackages.bash-language-server
        pyright
        ripgrep
        shellcheck
        tree-sitter
        yaml-language-server
      ];

      plugins =
        with pkgs.vimPlugins;
        [
          fugitive
          fzf-vim
          markdown-preview-nvim
          nvim-lspconfig
          nvim-treesitter.withAllGrammars
          plenary-nvim
          surround
          telescope-fzf-native-nvim
          telescope-nvim
          trouble-nvim
          vim-repeat
          vim-solarized8
          vim-unimpaired
        ]
        ++ cfg.extraPlugins;
    };
  };
}
