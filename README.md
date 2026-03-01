# SemiCode OS v2 "Genesis"

The world's first Linux distribution built for programmers and web developers — reimagined for the AI era.

SemiCode OS v2 is a customized Ubuntu 24.04 LTS desktop pre-loaded with AI coding tools, a full developer toolkit, and a thoughtfully configured GNOME desktop environment.

## What's Included

**AI Coding Tools:**
- Claude Code CLI
- OpenAI Codex CLI
- Aider (AI pair programming)

**Developer Environment:**
- VS Code with essential extensions
- Git, GitHub CLI, Neovim
- Languages: Python, Node.js, Go, Rust, Java, Ruby, PHP, Lua
- Containers: Docker, Podman, Kubernetes (kubectl, Helm), Terraform

**Desktop Experience:**
- GNOME with dark mode and Catppuccin Mocha terminal colors
- JetBrains Mono as default monospace font
- Developer-friendly keybindings and power settings
- Custom SemiCode branding and boot splash

## Building

See [BUILDING.md](BUILDING.md) for full build instructions.

**Quick start:**
```bash
# Using Docker (recommended)
docker build -t semicode-builder docker/
docker run --rm --privileged -v /proc:/proc -v $(pwd):/build semicode-builder ./scripts/build.sh

# Or natively on Ubuntu/Debian
sudo apt install live-build
sudo ./scripts/build.sh
```

The ISO will be output to `builds/amd64/`.

## Project Structure

```
SemiCodeOS/
├── scripts/           # Build scripts
├── etc/
│   ├── auto/          # live-build auto scripts
│   ├── config/
│   │   ├── package-lists/   # APT package lists
│   │   ├── hooks/live/      # Chroot hook scripts
│   │   └── includes.chroot/ # Files overlaid into the live filesystem
│   └── semicode-amd64.conf  # Build configuration
├── docker/            # Build container
├── branding/          # Source artwork and themes
└── .github/workflows/ # CI/CD pipelines
```

## Origins

SemiCode OS was originally created by a Sudanese development team as the world's first programming-focused Linux distribution. v1 was based on Ubuntu 14.04 with pre-installed IDEs, compilers, and dev tools. v2 revives the project for the AI era.

## License

GPL-3.0 — see [LICENSE](LICENSE).
