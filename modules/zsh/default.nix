{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "minimal";
    };
    # Cover non-login shells (scripts, nested zsh): /etc/zprofile is not run,
    # so path_helper never clobbers PATH and sourcing nix-daemon.sh suffices.
    envExtra = ''
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
    '';
    # Re-prepend nix profile paths after macOS /etc/zprofile runs path_helper,
    # which rebuilds PATH from /etc/paths{,.d} and drops nix entries.
    # nix-daemon.sh's idempotency guard prevents re-sourcing, so set PATH directly.
    initContent = ''
      export PATH="/nix/var/nix/profiles/default/bin:$HOME/.nix-profile/bin:$PATH"
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
