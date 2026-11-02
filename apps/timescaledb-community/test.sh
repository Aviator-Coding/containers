#!/usr/bin/env bash
# Smoke test run by build.yaml on pull requests: IMAGE and TAG are set by the workflow.
# The image is FROM scratch (no shell), so inspect its filesystem instead of running it.
set -euo pipefail

cid="$(docker create "${IMAGE}" /nonexistent)"
trap 'docker rm -f "${cid}" >/dev/null' EXIT
listing="$(docker export "${cid}" | tar -t)"

for path in "lib/timescaledb.so" "lib/timescaledb-${TAG}.so" "lib/timescaledb-tsl-${TAG}.so" \
    "share/extension/timescaledb.control" "share/extension/timescaledb--${TAG}.sql"; do
    grep -qx "${path}" <<<"${listing}" || { echo "missing ${path}" >&2; exit 1; }
done
echo "timescaledb ${TAG}: loader, apache and tsl modules, control file and SQL present"
