FROM ghcr.io/hugomods/hugo:base

WORKDIR /src

COPY . .

EXPOSE 80

CMD ["hugo", "server", "--bind", "0.0.0.0", "--port", "80", \
     "--baseURL", "http://localhost", "--appendPort=false"]
