#!/usr/bin/env bash
set -e
set -u
set -o pipefail

hyperfine \
  --export-json=benchmark-serve-hot.json \
  --warmup=1 \
  --time-unit=millisecond \
  --prepare='cd website-bunbuns && bun install && ../start-server.sh bun --bun run run-server-worker.mjs' 'cd website-bunbuns && bun run tools/check-links.mjs http://localhost:9001/' \
  --prepare='cd website-node-20 && yarn install && ../start-server.sh node run-server-worker.mjs' 'cd website-node-20 && node tools/check-links.mjs http://localhost:9001/' \
