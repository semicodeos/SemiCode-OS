# Building SemiCode OS

## Prerequisites

- Ubuntu 24.04 or Debian 12+ (for native builds)
- OR Docker (for containerized builds — recommended)
- At least 20 GB free disk space
- Internet connection (to download packages)

## Option 1: Docker Build (Recommended)

```bash
# Build the container
docker build -t semicode-builder docker/

# Build the ISO
docker run --rm --privileged \
  -v /proc:/proc \
  -v "$(pwd)":/build \
  semicode-builder ./scripts/build.sh
```

## Option 2: Native Build

```bash
# Install live-build
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
