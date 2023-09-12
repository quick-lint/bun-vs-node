#!/usr/bin/env bash
set -e
set -u
set -o pipefail

hyperfine \
  --export-json=benchmark-package-install-ci-warm-website.json \
  --warmup=2 \
  --time-unit=millisecond \
  --prepare='rm -rf website-node-20/node_modules/' 'cd website-node-20 && yarn install --immutable' \
  --prepare='rm -rf website-bunbuns/node_modules/' 'cd website-bunbuns && bun install --frozen-lockfile' \

hyperfine \
  --export-json=benchmark-package-install-ci-warm-analytics.json \
  --warmup=2 \
  --time-unit=millisecond \
  --prepare='rm -rf website-node-20/analytics/node_modules/' 'cd website-node-20/analytics && yarn install --immutable' \
  --prepare='rm -rf website-bunbuns/analytics/node_modules/' 'cd website-bunbuns/analytics && bun install --frozen-lockfile' \