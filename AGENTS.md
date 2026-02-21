# AGENTS.md

## Project Overview

This repository contains the source for `samantha.wiki`, a personal Hugo static site. The site is built into a Docker image, published to GitHub Container Registry (GHCR), and served from a self-hosted server.

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
├── themes/PaperMod/        # Forked PaperMod theme (git submodule, default branch)
├── Dockerfile              # Builds the Hugo site and serves it on port 80
├── docker-compose.yml      # Local compose config for the hugo service
├── hugo.yaml               # Hugo site configuration
└── CNAME                   # samantha.wiki
```

---

## Tech Stack

- **Static site generator**: [Hugo](https://gohugo.io/) extended, configured in `hugo.yaml`
- **Theme**: Forked PaperMod (`themes/PaperMod`, default branch) — includes custom comment support
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
CMD hugo server --bind 0.0.0.0 --port 80 --appendPort=false
```

The image copies all site source into `/src` and runs `hugo server` at startup. The host's reverse proxy is responsible for routing external traffic to the container.

### Local development with Docker

```bash
docker compose up --build
```

This builds the image locally and runs the Hugo server at `http://localhost:80`.

---

## Pushing to Main

After every push to `main`, monitor the GitHub Actions workflows to confirm they all pass before considering the task complete. Use:

```bash
gh run list --limit 5
gh run watch <run-id> --exit-status
```

All three workflows (Docker Smoke Test, Build and Push Docker Image, Docker Build and Push) must succeed. If any fail, investigate the logs and fix before moving on.

---

## CI/CD Workflows

| Workflow | File | Trigger | Purpose |
|----------|------|---------|---------|
| Docker Build | `docker-build.yml` | Push/PR to `main` | Builds image; pushes only on non-PR pushes |
| Docker Publish | `docker-publish.yml` | Push/PR to `main`, version tags | Builds + pushes to GHCR with full metadata tagging |
| Docker Smoke Test | `docker-test.yml` | Push/PR to `main` | Builds image and asserts the Hugo server returns HTTP 200 |

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

## Multi-Agent Workflow: Git Worktrees

**IMPORTANT**: When working on new features or any non-trivial changes, agents **must** use git worktrees to avoid conflicts with other agents that may be editing files concurrently.

### Why worktrees are required

Multiple agents may run in parallel against this repository. Without isolation, concurrent edits to the same files will cause merge conflicts, lost work, or corrupted state. Git worktrees give each agent a full, isolated copy of the repo on its own branch.

### How to use worktrees

1. **Create a worktree** before starting work on a new feature or change:
   ```bash
   git worktree add .claude/worktrees/<feature-name> -b <feature-branch> main
   ```
2. **Do all work** inside the worktree directory (`.claude/worktrees/<feature-name>/`).
3. **Commit and push** the feature branch from within the worktree.
4. **Open a PR** from the feature branch back to `main`.
5. **Clean up** the worktree after the PR is merged. Because this repo uses submodules, you must deinit them before removing the worktree:
   ```bash
   git -C .claude/worktrees/<feature-name> submodule deinit --all --force
   git worktree remove .claude/worktrees/<feature-name>
   ```
   If the worktree gets into a broken state (e.g. partially removed), run `git worktree prune` from the main working tree to clean up stale references.

### Rules

- **Never commit directly to `main`** when working as an agent alongside other agents. Always use a feature branch in a worktree.
- **One worktree per feature/task** — do not reuse worktrees across unrelated tasks.
- **Initialize submodules** in the new worktree if needed:
  ```bash
  git -C .claude/worktrees/<feature-name> submodule update --init
  ```

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


