# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a NixOS flake-based system configuration designed to work on both NixOS and macOS. It uses Home Manager for user-level configuration (settings only, no packages).

## Build Commands

Rebuild and switch to new configuration:
```bash
sudo nixos-rebuild switch --flake .#newt
```

Test configuration without making it permanent:
```bash
sudo nixos-rebuild test --flake .#newt
```

Build without switching (for validation):
```bash
nixos-rebuild build --flake .#newt
```

## Architecture

- `flake.nix` - Entry point defining inputs (nixpkgs, home-manager) and the single host configuration "newt"
- `hosts/newt/default.nix` - System-level NixOS configuration (bootloader, networking, services), imports system modules
- `hosts/newt/hardware-configuration.nix` - Auto-generated hardware config (do not edit manually)
- `users/feldsherov.nix` - Home Manager user configuration (programs/settings only, cross-platform)
- `modules/` - Reusable modules:
  - `misc-packages/default.nix` - System packages with platform conditionals (NixOS/nix-darwin module)
  - `sway/default.nix` - Sway window manager configuration, Linux-only (Home Manager module)
  - `vim/default.nix` - Neovim configuration, cross-platform (Home Manager module)

## Cross-Platform Design

- **Home Manager modules** (`users/`, `modules/sway/`, `modules/vim/`) = configuration only
- **System modules** (`modules/misc-packages/`) = package installation via `environment.systemPackages`
- Platform detection uses `pkgs.stdenv.isLinux` / `pkgs.stdenv.isDarwin` with `lib.mkIf` or `lib.optionals`
- The sway module is guarded with `lib.mkIf pkgs.stdenv.isLinux` so it's safe to import on macOS

## Key Design Decisions

- Uses nixpkgs unstable channel
- Home Manager is integrated as a NixOS module (not standalone)
- `home-manager.useGlobalPkgs = true` means Home Manager uses the system nixpkgs
- Flakes are enabled via `experimental-features = nix-command flakes`
- `NIXOS_OZONE_WL = "1"` is set system-wide for Wayland Electron apps (VSCode fix)
