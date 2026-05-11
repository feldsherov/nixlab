{ config, pkgs, ... }:

{
  home.packages = [ pkgs.kubectl ];

  programs.zsh.shellAliases = {
    k = "kubectl";
  };

  # The kubectl package ships share/zsh/site-functions/_kubectl, which zsh
  # picks up via Home Manager's fpath — no need to source completion at
  # shell startup. Just teach compdef that `k` should complete like kubectl.
  programs.zsh.initContent = ''
    compdef k=kubectl
  '';
}
