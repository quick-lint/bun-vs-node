#!/usr/bin/env bash
set -e
set -u
set -o pipefail

cc -O3 benchmark-reload.c -o benchmark-reload

./benchmark-reload \
  website-node-20/src/config.mjs \
  'Server running:' \
  '' \
  100 \
  sh -c 'cd website-node-20 && node run-server.mjs' \
  >benchmark-reload-server-chokidar.csv

./benchmark-reload \
  website-node-20/src/config.mjs \
  'Server running:' \
  '' \
  100 \
  sh -c 'cd website-node-20 && node --watch run-server-worker.mjs' \
  >benchmark-reload-server-node-20.csv

./benchmark-reload \
  website-bunbuns/src/config.mjs \
  'Server running:' \
  '' \
  100 \
  sh -c 'cd website-bunbuns && bun --bun run --watch run-server-worker.mjs' \
  >benchmark-reload-server-bunbuns.csv
