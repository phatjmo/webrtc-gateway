FROM debian:jessie
ENV DEBIAN_FRONTEND noninteractive

# RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xfb40d3e6508ea4c8

# 4.4.4 and higher
#RUN echo "deb http://deb.kamailio.org/kamailio jessie main" >> etc/apt/sources.list && \
#    echo "deb-src http://deb.kamailio.org/kamailio jessie main" >> etc/apt/sources.list

# Live dangerously!
#RUN echo "deb http://deb.kamailio.org/kamailiodev-nightly jessie main" >> etc/apt/sources.list && \
#    echo "deb-src http://deb.kamailio.org/kamailiodev-nightly jessie main" >> etc/apt/sources.list

# Access to 4.4.2
RUN echo "deb http://ftp.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/debian-backports.list

RUN apt-get update
RUN apt-get update -qq && apt-get install --no-install-recommends --no-install-suggests -qqy \
	apt-utils \
	rsyslog \
	inotify-tools \
	vim-tiny \
	curl \
	gettext \
	build-essential \
	git \
	ca-certificates \
	unzip \
	wget

#RUN wget -O- http://deb.kamailio.org/kamailiodebkey.gpg | sudo apt-key add -

RUN apt-get install --no-install-recommends --no-install-suggests -qqy \
	kamailio=4.4.2-3~bpo8+1 \
	kamailio-mysql-modules=4.4.2-3~bpo8+1 \
	kamailio-json-modules=4.4.2-3~bpo8+1  \
	kamailio-extra-modules=4.4.2-3~bpo8+1 \
	kamailio-utils-modules=4.4.2-3~bpo8+1 \
	kamailio-websocket-modules=4.4.2-3~bpo8+1 \
	kamailio-presence-modules=4.4.2-3~bpo8+1 \
	kamailio-tls-modules=4.4.2-3~bpo8+1
#RUN apt-get install --no-install-recommends --no-install-suggests -qqy \
#	kamailio \
#	#kamailio-autheph-modules \
#	#kamailio-berkeley-bin \
#	#kamailio-berkeley-modules \
#	kamailio-carrierroute-modules \
#	kamailio-cnxcc-modules \
#	kamailio-cpl-modules \
#	kamailio-dbg \
#	kamailio-dnssec-modules \
#	#kamailio-erlang-modules \
#	kamailio-extra-modules \
#	kamailio-geoip-modules \
#	kamailio-ims-modules \
#	#kamailio-java-modules \
#	kamailio-json-modules \
#	#kamailio-kazoo-modules \
#	kamailio-ldap-modules \
#	kamailio-lua-modules \
#	kamailio-memcached-modules \
#	kamailio-mono-modules \
#	kamailio-mysql-modules \
#	kamailio-nth \
#	kamailio-outbound-modules \
#	kamailio-perl-modules \
#	kamailio-postgres-modules \
#	kamailio-presence-modules \
#	kamailio-purple-modules \
#	kamailio-python-modules \
#	kamailio-radius-modules \
#	kamailio-redis-modules \
#	kamailio-sctp-modules \
#	kamailio-snmpstats-modules \
#	kamailio-sqlite-modules \
#	kamailio-tls-modules \
#	kamailio-unixodbc-modules \
#	kamailio-utils-modules \
#	kamailio-websocket-modules \
#	kamailio-xml-modules \
#	kamailio-xmpp-modules

# Install everything that matches kamailio-*
#RUN apt-cache search --quiet --names-only '^kamailio' | awk '{ print $1 }' | xargs apt-get install --no-install-recommends --no-install-suggests -qqy
#RUN rm -rf /var/lib/apt/lists/*

# Install supervisor plugin for stdout capture
RUN apt-get update -qq
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y python-pip python-dev build-essential rsyslog supervisor
RUN pip install supervisor-stdout

ADD https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 /usr/local/bin/jq
RUN chmod +x /usr/local/bin/jq

WORKDIR /

RUN update-ca-certificates

RUN cp -a /usr/share/kamailio/dbtext/kamailio/ /etc/kamailio/dbtext/

# copy files
ADD files/ /

RUN ln -s /usr/lib/x86_64-linux-gnu /usr/lib64

VOLUME /etc/kamailio

ENV SUPERVISOR_RUN="setup:* app:* logging:* support:*"

STOPSIGNAL SIGSTOP

CMD /kamailio.sh
