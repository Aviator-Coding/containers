#!/usr/bin/env bash
# Smoke test run by build.yaml on pull requests: IMAGE and VERSION are set by the workflow.
set -euo pipefail

docker run --rm "${IMAGE}" talosctl version --client | tee /dev/stderr | grep -q "Tag: *${VERSION}"
