#!/usr/bin/env bash
set -e
set -u
set -o pipefail

ssh qljs-analytics@c.quick-lint-js.com '
  cp analytics.sqlite3 analytics-bun-vs-node-node-20.sqlite3
  cp analytics-bun-vs-node-node-20.sqlite3 analytics-bun-vs-node-bunbuns.sqlite3

  PATH="${HOME}/bun-linux-x64-1.0.1:${PATH}"

  hyperfine \
    --export-json=benchmark-analytics-prod-incremental-import-apache-logs.json \
    --warmup=1 \
    --max-runs=3 \
    --style=full \
    "cd bun-vs-node-node-20 && node src/import-apache-logs.mjs" \
    "cd bun-vs-node-bunbuns && bun --bun run src/import-apache-logs.mjs"

  hyperfine \
    --export-json=benchmark-analytics-prod-incremental-import-matomo-logs.json \
    --warmup=1 \
    --max-runs=3 \
    --style=full \
    "cd bun-vs-node-node-20 && node src/import-matomo-logs.mjs" \
    "cd bun-vs-node-bunbuns && bun --bun run src/import-matomo-logs.mjs"

  hyperfine \
    --export-json=benchmark-analytics-prod-incremental-make-charts.json \
    --warmup=1 \
    --style=full \
    --max-runs=3 \
    "cd bun-vs-node-node-20 && node src/make-charts.mjs" \
    "cd bun-vs-node-bunbuns && bun --bun run src/make-charts.mjs"
'
