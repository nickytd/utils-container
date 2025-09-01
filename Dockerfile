# fetch containerd cli & kubectl tools
FROM curlimages/curl:8.15.0 AS downloader
ARG TARGETARCH
ENV CRICTL_VERSION="v1.34.0"
WORKDIR /tmp

# Download and extract crictl
RUN curl -LO https://github.com/kubernetes-sigs/cri-tools/releases/download/${CRICTL_VERSION}/crictl-${CRICTL_VERSION}-linux-${TARGETARCH}.tar.gz && \
    tar zxf crictl-${CRICTL_VERSION}-linux-${TARGETARCH}.tar.gz && \
    rm crictl-${CRICTL_VERSION}-linux-${TARGETARCH}.tar.gz && \
    chmod +x crictl

# Download kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${TARGETARCH}/kubectl" && \
    chmod +x kubectl

# Main image build
FROM debian:bookworm-slim

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Copy binaries from downloader stage
COPY --from=downloader /tmp/crictl /usr/local/bin/crictl
COPY --from=downloader /tmp/kubectl /usr/local/bin/kubectl

# Copy configuration files in single layer
COPY ./.tmux.conf /root/.tmux.conf
COPY ./.bash_aliases /root/.bash_aliases

# Install essential packages only, grouped by purpose
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        # Core utilities
        bash \
        curl \
        ca-certificates \
        # Network debugging (core set)
        dnsutils \
        iptables \
        iputils-ping \
        iproute2 \
        netcat-openbsd \
        socat \
        tcpdump \
        # System monitoring (essential)
        lsof \
        procps \
        systemd \
        # File/text processing
        jq \
        yq \
        # Terminal/editor
        tmux \
        nvi \
        && \
    # Thorough cleanup
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    # Create necessary directories
    mkdir -p /root/.config

# Set working directory
WORKDIR /root

# Default command
CMD ["tmux"]
