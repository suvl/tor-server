#
# Dockerfile for Tor Relay Server
#
# This will build & install a Tor Debian package using 
FROM alpine:3.7

# If no Nickname is set, a random string will be added to 'Tor4'
ENV TOR_NICKNAME=Tor4 \
    TERM=xterm \
    TOR_CONF=/etc/tor/torrc \
    TOR_LOG_DIR=/var/log/tor \
    DNSMASQ_CONF=/etc/dnsmasq.conf

# update and install tor
RUN echo '@edge http://dl-cdn.alpinelinux.org/alpine/edge/main' >> \
    	/etc/apk/repositories && \
    echo '@edge http://dl-cdn.alpinelinux.org/alpine/edge/community' >> \
    	/etc/apk/repositories && \
    apk add --update \
        dnsmasq \
	bash \
        tor@edge && \
        rm -rf /var/cache/apk/*


# copy docker config
COPY ./config/torrc /etc/tor/torrc

# Copy docker-entrypoint
COPY ./scripts/ /usr/local/bin/

# Persist data
VOLUME /etc/tor /var/lib/tor

RUN mkdir -p "$TOR_LOG_DIR" && \
    chown tor $TOR_CONF

# ORPort, DirPort, ObfsproxyPort
EXPOSE 9001 9030

ENTRYPOINT ["docker-entrypoint"]

CMD ["tor", "-f", "/etc/tor/torrc"]
#CMD "/bin/sh"
