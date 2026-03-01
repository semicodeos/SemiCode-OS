FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    live-build \
    debootstrap \
    ca-certificates \
    curl \
    gnupg \
    xorriso \
    squashfs-tools \
    grub-efi-amd64-bin \
    grub-pc-bin \
    mtools \
    dosfstools \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

CMD ["./scripts/build.sh"]
