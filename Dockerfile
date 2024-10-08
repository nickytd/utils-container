# build grpcurl
FROM golang:1.22 AS build
RUN go install github.com/fullstorydev/grpcurl/cmd/grpcurl@v1.9.1

# fetch containerd cli & kubectl tools
FROM curlimages/curl:8.10.1 AS curl
ARG TARGETARCH
ENV VERSION="v1.31.1"
WORKDIR /tmp
RUN curl -LO https://github.com/kubernetes-sigs/cri-tools/releases/download/${VERSION}/crictl-${VERSION}-linux-${TARGETARCH}.tar.gz && \
        tar zxvf crictl-${VERSION}-linux-${TARGETARCH}.tar.gz && \
        rm -f crictl-${VERSION}-linux-${TARGETARCH}.tar.gz && \
        curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${TARGETARCH}/kubectl

# build utils container image
FROM ubuntu:24.04
# pickup grpcurl from build image
COPY --from=build /go/bin/grpcurl /usr/local/bin
# pickup crictl from curl image
COPY --from=curl /tmp/crictl /usr/local/bin
# pickup kubectl from curl image
COPY --from=curl /tmp/kubectl /usr/local/bin
# install required binaries with os package manager
RUN apt-get update && apt-get install -y \
        bash \
        bridge-utils \
        cifs-utils \
        curl \
        dnsutils \
        fzf \
        fd-find \
        iotop \
        iperf \
        iptables \
        iputils-ping \
        jq \
        net-tools \
        netcat-traditional \
        nmap \
        procinfo \
        procps \
        smbclient \
        socat \
        stress \
        stress-ng \
        sysbench \
        systemd \
        tcpdump \
        vim \
        yq \
        wget && \
        apt-get autoremove --purge && apt-get clean
