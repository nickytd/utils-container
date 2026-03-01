# fetch containerd cli & kubectl tools
FROM curlimages/curl:8.18.0 AS downloader
ARG TARGETARCH
ENV CRICTL_VERSION="v1.35.0"
ENV WITR_VERSION="0.3.0"
WORKDIR /tmp

# Download and extract crictl
RUN curl -LO https://github.com/kubernetes-sigs/cri-tools/releases/download/${CRICTL_VERSION}/crictl-${CRICTL_VERSION}-linux-${TARGETARCH}.tar.gz && \
    tar zxf crictl-${CRICTL_VERSION}-linux-${TARGETARCH}.tar.gz && \
    rm crictl-${CRICTL_VERSION}-linux-${TARGETARCH}.tar.gz && \
    chmod +x crictl

# Download kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${TARGETARCH}/kubectl" && \
    chmod +x kubectl

# Download witr package for later installation in main image
RUN curl -Lo witr.deb https://github.com/pranshuparmar/witr/releases/download/v${WITR_VERSION}/witr-${WITR_VERSION}-linux-${TARGETARCH}.deb

# Main image build
FROM debian:bookworm-slim

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Copy binaries from downloader stage
COPY --from=downloader /tmp/crictl /usr/local/bin/crictl
COPY --from=downloader /tmp/kubectl /usr/local/bin/kubectl
COPY --from=downloader /tmp/witr.deb /witr.deb

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

# Install witr
RUN dpkg -i /witr.deb
RUN rm -f /witr.deb


# Set working directory
WORKDIR /root

# Default command
CMD ["tmux"]
