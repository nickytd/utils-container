# build grpcurl
FROM golang:1.24 AS build
RUN go install github.com/fullstorydev/grpcurl/cmd/grpcurl@v1.9.2
RUN go install github.com/mr-karan/doggo/cmd/doggo@v1.0.5

# fetch containerd cli & kubectl tools
FROM curlimages/curl:8.12.1 AS curl
ARG TARGETARCH
ENV VERSION="v1.32.0"
WORKDIR /tmp
RUN curl -LO https://github.com/kubernetes-sigs/cri-tools/releases/download/${VERSION}/crictl-${VERSION}-linux-${TARGETARCH}.tar.gz && \
        tar zxvf crictl-${VERSION}-linux-${TARGETARCH}.tar.gz && \
        rm -f crictl-${VERSION}-linux-${TARGETARCH}.tar.gz && \
        curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${TARGETARCH}/kubectl

# build utils container image
FROM ubuntu:25.04
# pickup grpcurl from build image
COPY --from=build /go/bin/grpcurl /usr/local/bin
# pickup doggo from build image
COPY --from=build /go/bin/doggo /usr/local/bin
# pickup crictl from curl image
COPY --from=curl /tmp/crictl /usr/local/bin
# pickup kubectl from curl image
COPY --from=curl /tmp/kubectl /usr/local/bin
# install required binaries with os package manager
RUN apt-get update && apt-get install -y \
        bash \
        bridge-utils \
        curl \
        dnsutils \
        fzf \
        fd-find \
        iftop \
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
        socat \
        stress \
        stress-ng \
        sysbench \
        tcpdump \
        tmux \
        vim \
        yq \
        wget && \
        apt-get autoremove --purge && apt-get clean
# copy tmux configuration
COPY ./.tmux.conf /root/.tmux.conf
# start tmux by default
CMD [ "tmux" ]
