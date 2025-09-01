# utils-container

A debian:bookworm-slim based image used for troubleshooting tasks.

## Added packages

### Core utilities

- bash
- curl
- ca-certificates

### Network debugging (core set)

- dnsutils
- iptables
- iputils-ping
- iproute2
- netcat-openbsd
- socat
- tcpdump

### System monitoring (essential)

- lsof
- procps
- systemd (journalctl, systemctl)

### File/text processing

- jq
- yq

### Terminal/editor

- tmux
- nvi

## Compiled tools

- crictl (from <https://github.com/kubernetes-sigs/cri-tools>)
- kubectl (from <https://dl.k8s.io/>)
