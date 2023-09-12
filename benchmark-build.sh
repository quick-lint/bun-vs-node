#!/usr/bin/env bash
set -e
set -u
set -o pipefail

hyperfine \
  --export-json=benchmark-build.json \
  --warmup=1 \
  --time-unit=millisecond \
  --prepare='rm -rf website-node-20/www/' 'cd website-node-20 && yarn build' \
  --prepare='rm -rf website-node-20/www/' 'cd website-node-20 && node run-build.mjs www' \
  --prepare='rm -rf website-bunnode/www/' 'cd website-bunnode && bun run run-build.mjs www' \
  --prepare='rm -rf website-bunbuns/www/' 'cd website-bunbuns && bun run run-build.mjs www'
