#!/usr/bin/env bash
# Smoke test run by build.yaml on pull requests: IMAGE and VERSION are set by the workflow.
set -euo pipefail

out="$(docker run --rm "${IMAGE}" talosctl version --client)"
echo "${out}"
grep -q "Tag: *${VERSION}" <<<"${out}"
