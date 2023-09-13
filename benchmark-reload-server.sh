#!/usr/bin/env bash
set -e
set -u
set -o pipefail

cc -O3 benchmark-reload.c -o benchmark-reload

echo "fixme: test is unreliable (chokidar gives sub-millisecond results sometimes)" >&2

(
  ./benchmark-reload \
    chokidar \
    website-node-20/src/config.mjs \
    'Server running:' \
    '' \
    100 \
    sh -c 'cd website-node-20 && node run-server.mjs'

  ./benchmark-reload \
    node-20 \
    website-node-20/src/config.mjs \
    'Server running:' \
    '' \
    100 \
    sh -c 'cd website-node-20 && node --watch run-server-worker.mjs'

  ./benchmark-reload \
    bunbuns \
    website-bunbuns/src/config.mjs \
    'Server running:' \
    '' \
    100 \
    sh -c 'cd website-bunbuns && bun --bun run --watch run-server-worker.mjs'
) >benchmark-reload-server.csv
