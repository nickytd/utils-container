FROM golang

RUN go get -u github.com/fullstorydev/grpcurl/cmd/grpcurl
RUN go build github.com/fullstorydev/grpcurl/cmd/grpcurl

FROM ubuntu
RUN apt-get update && apt-get install -y smbclient dnsutils tcpdump net-tools wget ruby netcat procinfo procps cifs-utils vim stress curl iputils-ping iptables stress-ng iotop jq
RUN apt-get autoremove --purge
RUN apt-get clean

COPY --from=0 grpcurl /usr/local/bin/grpcurl

CMD ["bash","-c"]
