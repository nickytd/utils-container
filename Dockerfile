# build grpcurl
FROM golang:1.22 as build
RUN go install github.com/fullstorydev/grpcurl/cmd/grpcurl@v1.9.1

# fetch containerd cli tool
FROM curlimages/curl:8.8.0 as curlimages
ARG TARGETARCH
ENV VERSION="v1.30.0"
WORKDIR /tmp
RUN curl -L https://github.com/kubernetes-sigs/cri-tools/releases/download/${VERSION}/crictl-${VERSION}-linux-${TARGETARCH}.tar.gz \
        --output crictl-${VERSION}-linux-${TARGETARCH}.tar.gz
RUN tar zxvf crictl-${VERSION}-linux-${TARGETARCH}.tar.gz && rm -f crictl-${VERSION}-linux-${TARGETARCH}.tar.gz

# build utils container image
FROM ubuntu:24.04
# pickup grpcurl from build
COPY --from=0 /go/bin/** /usr/local/bin
# pickup crictl from curlimages
COPY --from=1 /tmp/crictl /usr/local/bin
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
        wget && \
        apt-get autoremove --purge && apt-get clean
