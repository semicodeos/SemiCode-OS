# Building SemiCode OS

## Prerequisites

- Docker (for containerized builds — recommended)
- OR Debian 13 (trixie) with a modern live-build, for native builds
- At least 20 GB free disk space
- Internet connection (to download packages)

> **Note:** Ubuntu's archive ships an ancient `live-build` (3.0~a57) that
> cannot produce a bootable UEFI/Secure Boot image. The Docker builder uses
> Debian's modern live-build instead, which is why containerized builds are
> recommended.

## Option 1: Docker Build (Recommended)

```bash
# Build the container (Debian + modern live-build)
docker build -t semicode-builder docker/

# Build the ISO
docker run --rm --privileged \
  -v "$(pwd)":/build \
  semicode-builder ./scripts/build.sh
```

## Option 2: Native Build (Debian 13+)

```bash
# Requires a modern live-build (Debian trixie or newer). Ubuntu's
# live-build is too old and will fail at the bootloader stage.
sudo apt-get update
sudo apt-get install -y live-build debootstrap xorriso squashfs-tools \
  grub-efi-amd64-bin grub-pc-bin mtools dosfstools

# Build the ISO
sudo ./scripts/build.sh
```

## Output

The ISO file will be placed in `builds/amd64/semicode-os-2.0-amd64.iso`.

## Testing the ISO

Boot the ISO in QEMU:

```bash
qemu-system-x86_64 \
  -m 4096 \
  -enable-kvm \
  -cdrom builds/amd64/semicode-os-2.0-amd64.iso \
  -boot d
```

## Verification Checklist

After booting the live session, verify:

- [ ] GNOME desktop loads with dark theme
- [ ] Terminal opens with Catppuccin Mocha colors and JetBrains Mono font
- [ ] `claude --version` works
- [ ] `codex --version` works
- [ ] `code --version` works
- [ ] `git --version` works
- [ ] `node --version` works
- [ ] `python3 --version` works
- [ ] `docker --version` works
- [ ] `rustc --version` works
- [ ] Dock shows pinned apps at the bottom
- [ ] SemiCode wallpaper is set
- [ ] `semicode-ai-setup` shows all tools

## CI/CD

- **Tag push** (`v*`): Builds ISO and creates a draft GitHub Release
- **Weekly** (Monday 4am UTC): Builds ISO and uploads as artifact
- **PR validation**: Runs shellcheck, validates package lists and configs

## Project Structure

```
etc/
  auto/                    # live-build auto scripts
  semicode-amd64.conf      # Build configuration
  config/
    package-lists/         # APT package lists (one per category)
    hooks/live/            # Chroot hooks (run during build)
    includes.chroot/       # Files overlaid into the live filesystem
      etc/dconf/           # GNOME dconf settings
      etc/skel/            # Default user home files
      usr/share/           # Desktop entries, wallpapers, themes, icons
      usr/local/bin/       # Helper scripts
    includes.binary/       # Files overlaid into the ISO
      .disk/info           # ISO metadata
```
