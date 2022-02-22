FROM golang:1.17.7
RUN go install github.com/fullstorydev/grpcurl/cmd/grpcurl@v1.8.6

FROM ubuntu:22.04
RUN apt-get update && apt-get install -y smbclient dnsutils tcpdump net-tools wget ruby netcat procinfo procps cifs-utils vim stress curl iputils-ping iptables stress-ng iotop jq systemd
RUN apt-get autoremove --purge && apt-get clean

COPY --from=0 /go/bin/grpcurl /usr/local/bin/grpcurl

CMD ["bash","-c"]
