{ config, pkgs, lib, ... }:

let
  identities = [
    "$HOME/.ssh/id_ed25519"
    "$HOME/.ssh/hyperpod_svyatoslav.pem"
    "$HOME/.ssh/slava_dev.pem"
  ];

  sshExtraFlags = lib.optionalString pkgs.stdenv.isDarwin "--apple-use-keychain";

  loadLines = lib.concatMapStringsSep "\n    " (k:
    ''[ -f "${k}" ] && ssh-add ${sshExtraFlags} "${k}" >/dev/null 2>&1''
  ) identities;
in
{
  # Load known identities into the running ssh-agent at shell start. Skips
  # the work when the agent already has any keys loaded so we don't re-prompt
  # for passphrases on every new shell.
  programs.zsh.initContent = ''
    if [ -n "$SSH_AUTH_SOCK" ] && ! ssh-add -l >/dev/null 2>&1; then
        ${loadLines}
    fi
  '';
}
