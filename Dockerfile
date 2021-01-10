FROM rust:alpine AS builder

RUN apk add -q --no-cache git libc-dev build-base
RUN git clone --depth=1 https://github.com/shadowsocks/shadowsocks-rust.git
RUN cd shadowsocks-rust ; RUSTFLAGS="-C target-cpu=native" cargo build --release

FROM alpine:latest

LABEL maintainer "LJason <https://ljason.cn>"

COPY --from=builder /shadowsocks-rust/target/release/sslocal /usr/local/bin/sslocal
COPY --from=builder /shadowsocks-rust/target/release/ssserver /usr/local/bin/ssserver
COPY --from=builder /shadowsocks-rust/target/release/ssurl /usr/local/bin/ssurl
COPY --from=builder /shadowsocks-rust/target/release/ssmanager /usr/local/bin/ssmanager

RUN apk add -q --no-cache ca-certificates libev-dev && \
  apk add -q --no-cache --virtual .build-deps git build-base autoconf automake libtool asciidoc xmlto linux-headers && \
  git clone --depth=1 https://github.com/shadowsocks/simple-obfs.git && \
  cd simple-obfs ; git submodule update --init --recursive && \
  ./autogen.sh ; ./configure ; make ; make install && \
  cd .. ; rm -rf simple-obfs && \
  apk del -q --purge .build-deps

CMD ssserver -c /config.json
