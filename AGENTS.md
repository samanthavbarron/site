# AGENTS.md

## Project Overview

This repository contains the source for `samantha.wiki`, a personal Hugo static site. The site is built into a Docker image, published to GitHub Container Registry (GHCR), and served from a self-hosted server. A separate GitHub Pages deployment also exists for the same content.

---

## Repository Structure

```
.
├── .devcontainer/          # Dev container config (Ubuntu + Hugo + Docker)
├── .github/workflows/      # CI/CD pipelines
├── archetypes/             # Hugo content templates
├── assets/data/            # YAML data files
├── content/                # Site content (posts, papers, projects, cv, images)
├── layouts/                # Custom Hugo layouts and shortcodes
├── scripts/                # Automation scripts (pending removal — see below)
├── themes/PaperMod/        # Forked PaperMod theme (git submodule, branch: v8.0-comments)
├── Dockerfile              # Builds the Hugo site and serves it on port 80
├── docker-compose.yml      # Local compose config for the hugo service
├── hugo.yaml               # Hugo site configuration
└── CNAME                   # samantha.wiki (for GitHub Pages)
```

---

## Tech Stack

- **Static site generator**: [Hugo](https://gohugo.io/) extended, configured in `hugo.yaml`
- **Theme**: Forked PaperMod (`themes/PaperMod`, branch `v8.0-comments`) — includes custom comment support
- **Container runtime**: Docker (image served on port 80 inside the container)
- **Registry**: GitHub Container Registry (`ghcr.io/<owner>/<repo>`)
- **CI/CD**: GitHub Actions (see `.github/workflows/`)

---

## Deployment Notes

### How it works

This repo builds and publishes a Docker image to GHCR. That image runs the Hugo development server bound to port 80 inside the container. There is **no reverse proxy configuration needed here** — the host server that consumes the image handles all TLS termination and reverse proxying externally.

The host runs a `docker compose` setup that references the GHCR image. [What's Up Docker (WUD)](https://getwud.github.io/wud/#/configuration/) is used on that host to watch the GHCR image for updates and automatically pull and redeploy when a new image is pushed.

### Image tags

The `docker-publish.yml` workflow (the primary publish pipeline) produces these tags on pushes to `main` or tags:

| Tag | When applied |
|-----|-------------|
| `ghcr.io/<repo>:main` | Every push to `main` |
| `ghcr.io/<repo>:<sha>` | Every push (unique per commit) |
| `ghcr.io/<repo>:<semver>` | When a version tag (e.g., `v1.2.3`) is pushed |

WUD on the host should be pointed at the `:latest` or `:main` tag to pick up automatic updates.

> **Note**: There are two Docker workflows (`docker-build.yml` and `docker-publish.yml`). `docker-publish.yml` is the more complete one with metadata-based tagging. If only one is needed, consider removing the redundant workflow.

### Dockerfile summary

```dockerfile
FROM ghcr.io/hugomods/hugo:base
WORKDIR /src
COPY . .
EXPOSE 80
CMD hugo server --bind 0.0.0.0 --port 80 --baseURL http://localhost --appendPort=false
```

The image copies all site source into `/src` and runs `hugo server` at startup. The host's reverse proxy is responsible for routing external traffic to the container.

### Local development with Docker

```bash
docker compose up --build
```

This builds the image locally and runs the Hugo server at `http://localhost:80`.

---

## CI/CD Workflows

| Workflow | File | Trigger | Purpose |
|----------|------|---------|---------|
| Hugo Pages | `hugo.yaml` | Push to `main`, manual | Builds and deploys to GitHub Pages |
| Docker Build | `docker-build.yml` | Push/PR to `main` | Builds image; pushes only on non-PR pushes |
| Docker Publish | `docker-publish.yml` | Push/PR to `main`, version tags | Builds + pushes to GHCR with full metadata tagging |
| Bookmarks Sync | `bookmarks.yaml` | Daily at 00:00 UTC, manual | **Deprecated — pending removal** |

---

## Content Management

- **Manual edits**: Edit files in `content/` and push to `main`. GitHub Actions will rebuild automatically.
---

## Dev Container

The `.devcontainer/` setup provisions an Ubuntu-based container with:

- **Hugo extended** (latest release, auto-detected architecture)
- **Docker CE + Compose plugin** (via Docker-in-Docker feature)
- **Claude Code** VS Code extension

To use: open the repo in VS Code and select "Reopen in Container".

---

## Hugo Configuration Highlights

- **Base URL**: `https://samantha.wiki`
- **Theme**: PaperMod (custom fork with comments)
- **Outputs**: HTML, RSS, JSON (JSON powers the Fuse.js search)
- **Minification**: enabled for all output except XML
- **Drafts/future/expired content**: all disabled in builds
- **Submodule**: `themes/PaperMod` must be initialized — clone with `git clone --recurse-submodules` or run `git submodule update --init`

---

## Common Tasks

**Build the site locally (without Docker):**
```bash
hugo --gc --minify
```

**Run the Hugo dev server locally:**
```bash
hugo server
```

**Build and push Docker image manually:**
```bash
docker build -t ghcr.io/<owner>/<repo>:latest .
docker push ghcr.io/<owner>/<repo>:latest
```


## Deprecated / Pending Removal

The following are no longer in use and will be removed:

- `scripts/bookmarks.py` — Hoarder bookmark sync script
- `.github/workflows/bookmarks.yaml` — scheduled workflow that ran the sync
- `content/bookmarks/` — bookmark content directory

Do not add new functionality that depends on any of these. Do not worry about preserving their behavior when making other changes.
