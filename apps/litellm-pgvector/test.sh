#!/usr/bin/env bash
# Smoke test run by build.yaml on pull requests: IMAGE is set by the workflow.
# No database here, so only prove the venv, the generated prisma client and the
# shipped query engine are in place.
set -euo pipefail

docker run --rm "${IMAGE}" sh -ec '
  test -x /opt/prisma/query-engine
  python -c "import prisma, fastapi, uvicorn; print(\"prisma\", prisma.__version__)"
  test -f /app/main.py
'
