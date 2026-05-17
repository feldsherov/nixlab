{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    extraConfig = ''
      " Show line numbers
      set number
      
      " No tabs, tabs width 4
      set tabstop=4
      set shiftwidth=4
      set expandtab

      syntax on

      " Use terminal colors (16-color palette from kitty/iTerm)
      set notermguicolors
      colorscheme default

      " Enable powerline fonts for airline
      let g:airline_powerline_fonts = 1
      
      " Show whitespace characters.
      set listchars=eol:↵,trail:~,tab:>-,nbsp:+,eol:$
    '';

    plugins = with pkgs.vimPlugins; [
      vim-nix
      nerdtree
      vim-airline
      vim-tmux-navigator
    ];

    viAlias = true;
    vimAlias = true;
  };
}
