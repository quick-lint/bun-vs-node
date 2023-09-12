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
  --command-name='Jasmine yarn' 'cd website-node-14 && ../inaterm yarn test' \
  --command-name='Jasmine Node.js' 'cd website-node-14 && ../inaterm node run-tests.mjs' \
  --command-name='Node.js --test' 'cd website-node-20 && ../inaterm node --test' \
  --command-name='Jasmine Bun' 'cd website-bunmine && ../inaterm bun --bun run run-tests.mjs' \
  --command-name='Bun test, Node.js HTTP' 'cd website-bunnode && ../inaterm bun test' \
  --command-name='Bun test, Bun HTTP' 'cd website-bunbuns && ../inaterm bun test'
