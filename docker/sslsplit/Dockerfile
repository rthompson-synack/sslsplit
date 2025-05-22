FROM alpine:3.21 as builder

# Install build dependencies
RUN apk add --no-cache \
    gcc \
    musl-dev \
    make \
    libc-dev \
    linux-headers \
    git \
    libressl-dev \
    libevent-dev \
    libpcap-dev \
    libnet-dev \
    fts-dev \
    check-dev \
    openssl

# Copy source code
COPY . /opt/sslsplit
COPY patch/GNUmakefile /sslsplit/GNUmakefile
COPY patch/pxyconn.c   /sslsplit/pxyconn.c
WORKDIR /opt/sslsplit

# Set environment variables for build
ENV LIBS="-lfts"
ENV TCPPFLAGS="-DDOCKER"

# Build the binary
RUN export SOURCE_DATE_EPOCH=$(stat -c '%Y' *.c *.h|sort -r|head -1) && \
    make clean && make all

# Identify runtime dependencies
RUN mkdir -p /deps && \
    ldd /opt/sslsplit/sslsplit | grep "=> /" | awk '{print $3}' | xargs -I '{}' cp -v '{}' /deps/

# Final image
FROM alpine:3.21

# Install minimal dependencies
RUN apk add --no-cache fts

# Copy binary and its dependencies
COPY --from=builder /opt/sslsplit/sslsplit /usr/local/bin/sslsplit
COPY --from=builder /deps/* /usr/lib/

WORKDIR /root/
RUN chmod +x /usr/local/bin/sslsplit

ENTRYPOINT ["sslsplit"]
CMD ["-V"]

