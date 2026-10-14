FROM debian:trixie-slim

# HugoMods' moving base tag lags the upstream release. Install the official
# extended binary, verifying the published checksum for each build platform.
ARG TARGETARCH
RUN apt-get update \
  && apt-get install -y --no-install-recommends ca-certificates curl libstdc++6 \
  && rm -rf /var/lib/apt/lists/* \
  && case "$TARGETARCH" in \
    amd64) checksum=787f100057328824f38c6ad7c87ff10d6451ae0a7bc39cedaad0dd2bcde17e53 ;; \
    arm64) checksum=b975ba150a464f57115bdf6cbf6638224906461fdcf863821ec983f8602a442c ;; \
    *) exit 1 ;; \
  esac \
  && curl -fsSL "https://github.com/gohugoio/hugo/releases/download/v0.168.0/hugo_extended_0.168.0_linux-${TARGETARCH}.tar.gz" -o /tmp/hugo.tar.gz \
  && echo "$checksum  /tmp/hugo.tar.gz" | sha256sum -c - \
  && tar -xzf /tmp/hugo.tar.gz -C /usr/local/bin hugo \
  && rm /tmp/hugo.tar.gz \
  && hugo version

WORKDIR /src

COPY . .

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD curl -sf http://localhost/ > /dev/null

CMD ["hugo", "server", \
  "--bind", "0.0.0.0", \
  "--port", "80", \
  "--baseURL", "https://samantha.wiki/", \
  "--appendPort=false" \
]
