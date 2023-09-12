#!/usr/bin/env bash
set -e
set -u
set -o pipefail

cc -O3 inaterm.c -o inaterm
# HACK(strager): --ignore-failure is there for website-bunmine. See test.sh.
hyperfine \
  --ignore-failure \
  --export-json=benchmark-test.json \
  --warmup=2 \
  --time-unit=millisecond \
  'cd website-node-14 && ../inaterm yarn test' \
  'cd website-node-14 && ../inaterm node run-tests.mjs' \
  'cd website-node-20 && ../inaterm node --test' \
  'cd website-bunmine && ../inaterm bun --bun run run-tests.mjs' \
  'cd website-bunnode && ../inaterm bun test' \
  'cd website-bunbuns && ../inaterm bun test'
