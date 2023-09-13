#!/usr/bin/env bash
set -e
set -u
set -o pipefail

(cd website-bunbuns && ../start-server.sh bun --bun run run-server-worker.mjs)
(cd benchmark-page-latency && node index.mjs >../benchmark-page-latency-bunbuns.csv)

(cd website-node-20 && ../start-server.sh node run-server-worker.mjs)
(cd benchmark-page-latency && node index.mjs >../benchmark-page-latency-node-20.csv)
