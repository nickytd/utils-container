# build grpcurl
FROM --platform=${BUILDPLATFORM} golang:1.19.1 as build
ARG TARGETARCH
RUN GOOS=linux GOARCH=${TARGETARCH} go install github.com/fullstorydev/grpcurl/cmd/grpcurl@v1.8.7

# build utils container image
FROM --platform=${BUILDPLATFORM} ubuntu:22.04
ARG TARGETARCH

# pickup grpcurl from build
COPY --from=0 /go/bin/** /usr/local/bin
# install required binaries with os package manager
RUN <<EOT bash
  apt-get update
  apt-get install -y smbclient dnsutils tcpdump net-tools wget ruby netcat procinfo \
    procps cifs-utils vim stress curl iputils-ping iptables stress-ng iotop jq systemd sysbench
  apt-get autoremove --purge && apt-get clean
EOT

# fetch containerd cli tool
ENV VERSION="v1.25.0"
RUN curl -L https://github.com/kubernetes-sigs/cri-tools/releases/download/${VERSION}/crictl-${VERSION}-linux-${TARGETARCH}.tar.gz \
        --output crictl-${VERSION}-linux-${TARGETARCH}.tar.gz
RUN tar zxvf crictl-${VERSION}-linux-${TARGETARCH}.tar.gz -C /usr/local/bin
RUN rm -f crictl-${VERSION}linux-${TARGETARCH}.tar.gz