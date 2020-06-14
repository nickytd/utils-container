FROM ubuntu

RUN apt-get update && apt-get install -y smbclient dnsutils tcpdump net-tools wget ruby netcat procinfo procps cifs-utils vim stress curl iputils-ping iptables stress-ng
RUN apt-get autoremove --purge
RUN apt-get clean

CMD /bin/bash
