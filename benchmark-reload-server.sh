#!/usr/bin/env bash
set -e
set -u
set -o pipefail

cc -O3 benchmark-reload-server.c -o benchmark-reload-server

./benchmark-reload-server \
  website-node-20/src/config.mjs \
  sh -c 'cd website-node-20 && node run-server.mjs' \
  >benchmark-reload-server-chokidar.csv

./benchmark-reload-server \
  website-node-20/src/config.mjs \
  sh -c 'cd website-node-20 && node --watch run-server-worker.mjs' \
  >benchmark-reload-server-node-20.csv

./benchmark-reload-server \
  website-bunbuns/src/config.mjs \
  sh -c 'cd website-bunbuns && bun run --watch run-server-worker.mjs' \
  >benchmark-reload-server-bunbuns.csv
