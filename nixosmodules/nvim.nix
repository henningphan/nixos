{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    configure = {
      customRC = ''
        set nocompatible
        set tabstop=4
        set path+=**
        set shiftwidth=4
        set expandtab
        set smartindent
        set number
        set cursorcolumn
        syntax enable
        highlight CursorColumn ctermbg=Black
        set cursorline

        nnoremap eu :w<CR>
        nnoremap eo :q<CR>
        set background=dark
        colorscheme solarized8_flat
        :highlight ExtraWhitespace ctermbg=red guibg=red
        match ExtraWhitespace /\s\+$/
      '';

      packages.myVimPackage = with pkgs.vimPlugins; {
        # loaded on launch
        start = [
          fugitive
          fzf-vim
          vim-solarized8
          surround
        ];
        # manually loadable by calling `:packadd $plugin-name`
        opt = [ ];
      };
    };
  };
}
