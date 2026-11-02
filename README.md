# containers

Container images for [home-ops](https://github.com/Aviator-Coding/home-ops) that no upstream publishes. Same shape as [home-operations/containers](https://github.com/home-operations/containers), scaled down.

| Image | What | Consumer in home-ops | Version comes from |
|---|---|---|---|
| `ghcr.io/aviator-coding/talosctl-busybox` | busybox + `talosctl` | ARC runner init container (`actions-runner-system`) | Renovate: `ghcr.io/siderolabs/talosctl` tag |
| `ghcr.io/aviator-coding/timescaledb-community` | TimescaleDB Community Edition as a CloudNativePG ImageVolume extension (the official `timescaledb-oss` image is Apache-2 only) | `cloudnative-pg/cluster-18` | Renovate: Debian package on packagecloud |
| `ghcr.io/aviator-coding/litellm-pgvector` | BerriAI/litellm-pgvector from a pinned commit plus local patches | `ai/litellm-pgvector` | by hand: `VERSION` in its `docker-bake.hcl` |

## Layout

```
apps/<app>/Dockerfile        # the build
apps/<app>/docker-bake.hcl   # VERSION (+ Renovate annotation) and platforms
apps/<app>/test.sh           # smoke test run on pull requests (optional)
.github/workflows/build.yaml # one workflow: changed apps -> matrix build
```

## How a build works

- A **pull request** builds the changed apps for `linux/amd64`, loads the image and runs `test.sh`. Nothing is pushed.
- A **push to main** (or `gh workflow run build.yaml -f app=<app>`) builds every platform in the bake file and pushes `ghcr.io/aviator-coding/<app>:<tag>` and `:rolling`. The tag is `VERSION` up to the first `~`.
- Tags are **mutable**: a base-image refresh rebuilds the same tag with a new digest. home-ops pins `<tag>@sha256:<digest>` and Renovate there moves the digest. The run summary prints the exact reference to pin.

## Changing an image

1. Edit `apps/<app>/`. For `litellm-pgvector`, bump `VERSION` in `docker-bake.hcl` whenever the upstream commit, a patch or `constraints.txt` changes.
2. Open a PR; the Build check builds and tests it.
3. Merge; the push build publishes it. Then bump the tag (or digest) in home-ops, where `Image Pull` proves the cluster can pull it.

Local build: `cd apps/<app> && docker buildx bake` produces `<app>:<VERSION>` in the local Docker daemon.

## Development

```bash
mise install && mise run setup-dev-env   # pre-commit: yamllint, actionlint, zizmor, shellcheck, yamlfmt, commitlint
```

Commits follow `type(scope): description` with the app name as scope.
