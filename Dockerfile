# build grpcurl
FROM --platform=${BUILDPLATFORM} golang:1.19.1 as build
ARG TARGETARCH
RUN GOOS=linux GOARCH=${TARGETARCH} go install github.com/fullstorydev/grpcurl/cmd/grpcurl@v1.8.7

# fetch containerd cli tool
FROM --platform=${BUILDPLATFORM} curlimages/curl:7.85.0 as curlimages
ARG TARGETARCH
ENV VERSION="v1.25.0"
WORKDIR /tmp
RUN curl -L https://github.com/kubernetes-sigs/cri-tools/releases/download/${VERSION}/crictl-${VERSION}-linux-${TARGETARCH}.tar.gz \
        --output crictl-${VERSION}-linux-${TARGETARCH}.tar.gz
RUN tar zxvf crictl-${VERSION}-linux-${TARGETARCH}.tar.gz
RUN rm -f crictl-${VERSION}-linux-${TARGETARCH}.tar.gz

# build utils container image
FROM --platform=${TARGETPLATFORM} ubuntu:22.04
ARG TARGETARCH
# pickup grpcurl from build
COPY --from=0 /go/bin/** /usr/local/bin
# pickup crictl from curlimages
COPY --from=1 /tmp/crictl /usr/local/bin
# install required binaries with os package manager
RUN apt-get update
RUN apt-get install -y smbclient dnsutils tcpdump net-tools wget ruby netcat procinfo \
    procps cifs-utils vim stress curl iputils-ping iptables stress-ng iotop jq systemd sysbench
RUN apt-get autoremove --purge && apt-get clean