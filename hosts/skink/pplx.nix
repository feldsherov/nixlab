{ config, pkgs, lib, ... }:

let
  # Location of the Perplexity repo checkout. Adjust if cloned elsewhere.
  pplxAgiDir = "$HOME/pplx/agi";
in
{
  programs.zsh.initContent = ''
    # Perplexity development helpers
    if [ -f "${pplxAgiDir}/scripts/development/dev_zsh_init.zsh" ]; then
      source "${pplxAgiDir}/scripts/development/dev_zsh_init.zsh"
    fi
  '';
}
