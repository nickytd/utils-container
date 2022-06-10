FROM golang:1.18
RUN go install github.com/fullstorydev/grpcurl/cmd/grpcurl@v1.8.6

FROM ubuntu:22.04
RUN apt-get update && apt-get install -y smbclient dnsutils tcpdump net-tools wget ruby netcat procinfo procps cifs-utils vim stress curl iputils-ping iptables stress-ng iotop jq systemd
RUN apt-get autoremove --purge && apt-get clean

COPY --from=0 /go/bin/grpcurl /usr/local/bin/grpcurl

ENV VERSION="v1.24.1"
RUN curl -L https://github.com/kubernetes-sigs/cri-tools/releases/download/$VERSION/crictl-${VERSION}-linux-amd64.tar.gz --output crictl-${VERSION}-linux-amd64.tar.gz
RUN tar zxvf crictl-$VERSION-linux-amd64.tar.gz -C /usr/local/bin
RUN rm -f crictl-$VERSION-linux-amd64.tar.gz

CMD ["bash","-c"]
