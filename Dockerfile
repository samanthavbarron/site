FROM ghcr.io/hugomods/hugo:base

WORKDIR /src

COPY . .

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD curl -sf http://localhost/ > /dev/null

CMD ["hugo", "server", "--bind", "0.0.0.0", "--port", "80", \
     "--baseURL", "http://localhost", "--appendPort=false"]
