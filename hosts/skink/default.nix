{ nixpkgs }:

{
  pkgs = nixpkgs.legacyPackages.aarch64-darwin;
  modules = [
    ../../users/feldsherov.nix
    ../../modules/iterm2/default.nix
    # Re-prepend in initContent (not home.sessionPath) because macOS
    # /etc/zprofile runs path_helper after zshenv and rebuilds PATH.
    {
      programs.zsh.initContent = ''
        export PATH="$HOME/.local/bin:$PATH"
      '';
    }
  ];
}
