#!/usr/bin/env bash
set -e
set -u
set -o pipefail

cc -O3 benchmark-reload.c -o benchmark-reload

echo "fixme: test is unreliable (bunbuns-website gives sub-second results sometimes)" >&2

(
  ./benchmark-reload \
    bunbuns-website \
    website-bunbuns/src/timestamp.mjs \
    'bun test' \
    ' tests across ' \
    5 \
    sh -c 'cd website-bunbuns && bun test --watch'

  ./benchmark-reload \
    bunbuns-analytics \
    website-bunbuns/analytics/src/parse-log-file.mjs \
    'bun test' \
    ' tests across ' \
    100 \
    sh -c 'cd website-bunbuns/analytics && bun test --watch'
) >benchmark-reload-test.csv
