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
      
      " Show whitespace characters.
      set listchars=eol:↵,trail:~,tab:>-,nbsp:+,eol:$
    '';

    plugins = with pkgs.vimPlugins; [
      vim-nix
      nerdtree
      vim-airline
    ];
  };
}
