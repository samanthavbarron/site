FROM ghcr.io/hugomods/hugo:base

WORKDIR /src

COPY . .

# Clone the PaperMod theme (submodule must be initialized separately)
RUN git clone --depth 1 --branch v8.0-comments \
    https://github.com/samanthavbarron/hugo-PaperMod.git \
    themes/PaperMod

EXPOSE 80

CMD ["hugo", "server", "--bind", "0.0.0.0", "--port", "80", \
     "--baseURL", "http://localhost", "--appendPort=false"]
