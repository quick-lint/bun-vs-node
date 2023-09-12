#!/usr/bin/env bash
set -e
set -u
set -o pipefail

cc -O3 benchmark-reload.c -o benchmark-reload

./benchmark-reload \
  website-bunbuns/src/timestamp.mjs \
  'bun test' \
  ' tests across ' \
  5 \
  sh -c 'cd website-bunbuns && bun test --watch' \
  >benchmark-reload-test-website-bunbuns.csv

./benchmark-reload \
  website-bunbuns/analytics/src/parse-log-file.mjs \
  'bun test' \
  ' tests across ' \
  100 \
  sh -c 'cd website-bunbuns/analytics && bun test --watch' \
  >benchmark-reload-test-analytics-bunbuns.csv
