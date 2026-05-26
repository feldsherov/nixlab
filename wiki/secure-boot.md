# Secure Boot on `newt`

Secure Boot is set up via [lanzaboote](https://github.com/nix-community/lanzaboote),
the de-facto NixOS implementation. Stock NixOS uses `systemd-boot`, which loads
an unsigned kernel + initrd + cmdline triple — Secure Boot firmware will refuse
to launch that. lanzaboote replaces the stub with a signed **Unified Kernel
Image (UKI)** (kernel + initrd + cmdline bundled into one PE binary) that the
firmware can verify against keys we own.

## What's in the repo

- `flake.nix` — adds the `lanzaboote` input (pinned to a tag). Avoid the
  v0.4.x line: its `rust-overlay` pin is from late 2024 and fetches a
  `rustc-1.78.0` tarball with a fetcher that doesn't set a filename, so the
  unpacker fails with `do not know how to unpack source archive .../unknown`.
  v1.0.0+ ships a fresh `rust-overlay`.
- `modules/secure-boot/default.nix` — installs `sbctl`, force-disables
  `systemd-boot`, and enables `boot.lanzaboote` with the PKI bundle at
  `/var/lib/sbctl`.
- `hosts/newt/default.nix` — imports the module.

Disabling the module cleanly falls back to `systemd-boot` (the host still
declares `boot.loader.systemd-boot.enable = true`; the module overrides it
with `lib.mkForce`).

## Key concepts

- **Platform Key (PK), KEK, db, dbx** — the four UEFI variables the firmware
  uses to authenticate boot binaries. `sbctl` generates a self-owned PK/KEK/db
  set and enrolls them.
- **Setup Mode** — UEFI state where the PK is empty, so new keys can be
  enrolled without the vendor's signature. You enter Setup Mode by clearing
  Secure Boot keys in firmware.
- **`sbctl`** — userland tool that creates keys, signs files lanzaboote
  produces, and enrolls keys into UEFI variables.
- **`--microsoft`** flag for `enroll-keys` — also enrolls Microsoft's KEK + db
  so externally-signed firmware (option ROMs, GPU vBIOS, dual-boot Windows)
  keeps working. Skip it only if you want a fully self-signed boot path and
  understand the consequences.

## Out-of-repo actions (run these on `newt`)

The repo changes don't take effect until you (a) build a system with lanzaboote
and (b) get the firmware into a state where it trusts your keys. Order matters:
**create keys before rebuilding** so lanzaboote has something to sign with.

### 1. Put firmware into Setup Mode

Reboot into UEFI setup (often `F2`/`Del` at POST). In the Secure Boot menu:

- Set Secure Boot mode to **Custom** / **Setup Mode**.
- **Clear / Delete all Secure Boot keys** (sometimes labelled "Erase all
  variables" or "Reset to Setup Mode").
- Leave Secure Boot **disabled** for now (we re-enable it after enrolment).

Save and boot back into NixOS.

### 2. Verify Setup Mode

```bash
sudo sbctl status
```

Expect `Setup Mode: Enabled` and `Secure Boot: Disabled`. If Setup Mode is
disabled, go back to firmware and clear keys again.

### 3. Generate keys

```bash
sudo sbctl create-keys
```

Writes PK/KEK/db to `/var/lib/sbctl/` (the `pkiBundle` path the module points
at). Back this directory up somewhere safe — losing it means re-enrolling from
firmware.

### 4. Rebuild with lanzaboote

```bash
cd ~/nixlab
sudo nixos-rebuild switch --flake .#newt
```

lanzaboote builds a signed UKI for the current and previous generations using
the keys from step 3.

### 5. Verify every boot file is signed

```bash
sudo sbctl verify
```

All EFI binaries lanzaboote installed should print `is signed`. Anything
unsigned will fail to boot once Secure Boot is on.

### 6. Enrol keys into firmware

```bash
sudo sbctl enroll-keys --microsoft
```

Drop `--microsoft` only if you don't dual-boot Windows and don't have
firmware/option ROMs signed by Microsoft (rare on modern laptops/desktops —
many GPUs and NICs need it).

### 7. Reboot, enable Secure Boot in firmware

In UEFI setup, flip Secure Boot back to **Enabled** (Standard / User mode).
Save and boot.

### 8. Confirm it took

```bash
bootctl status | grep -i "secure boot"
# expect: Secure Boot: enabled (user)

sudo sbctl status
# expect: Setup Mode: Disabled, Secure Boot: Enabled
```

## Day-to-day

`nixos-rebuild switch` will sign new generations automatically — no extra step.
Kernel modules out-of-tree (DKMS-style) generally still work because lanzaboote
signs the bundled initrd, not individual modules; the kernel itself doesn't
enforce module signatures unless you set `module.sig_enforce=1`.

If you ever change the PKI bundle path or rotate keys, repeat steps 3–7.

## Recovery

If a rebuild produces an unbootable UKI:

- Boot the previous generation from the systemd-boot menu (lanzaboote keeps
  the entry list).
- If even that fails, boot a NixOS installer ISO with Secure Boot disabled in
  firmware, mount the root, and either roll back (`nixos-rebuild
  --rollback`) or remove the `secure-boot` import and rebuild.

Keep a copy of `/var/lib/sbctl` somewhere off-machine.
