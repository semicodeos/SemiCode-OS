# Debian provides a modern live-build (xorriso-based, with proper UEFI +
# Secure Boot support). Ubuntu's archive still ships the ancient live-build
# 3.0~a57 fork, which cannot produce a bootable grub-efi image — so we build
# the Ubuntu-based ISO from a Debian host instead.
FROM --platform=linux/amd64 debian:trixie-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    live-build \
    debootstrap \
    ca-certificates \
    curl \
    wget \
    gnupg \
    gpgv \
    xorriso \
    squashfs-tools \
    grub-efi-amd64-bin \
    grub-pc-bin \
    grub-common \
    mtools \
    dosfstools \
    cpio \
    rsync \
    && rm -rf /var/lib/apt/lists/*

# debootstrap on a Debian host needs the Ubuntu archive keyring to verify the
# noble Release file; it is not packaged in Debian, so fetch the latest deb
# from the Ubuntu pool and install it (provides
# /usr/share/keyrings/ubuntu-archive-keyring.gpg).
RUN set -eux; \
    base="http://archive.ubuntu.com/ubuntu/pool/main/u/ubuntu-keyring/"; \
    deb="$(curl -fsSL "$base" | grep -oE 'ubuntu-keyring_[0-9.]+_all\.deb' | sort -V | tail -1)"; \
    curl -fsSL -o /tmp/ubuntu-keyring.deb "${base}${deb}"; \
    dpkg -i /tmp/ubuntu-keyring.deb; \
    rm -f /tmp/ubuntu-keyring.deb

WORKDIR /build

CMD ["./scripts/build.sh"]
