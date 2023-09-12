#!/usr/bin/env bash
set -e
set -u
set -o pipefail

hyperfine \
  --export-json=benchmark-package-install-ci-hot-website.json \
  --warmup=2 \
  --time-unit=millisecond \
  'cd website-node-20 && yarn install --immutable' \
  'cd website-bunbuns && bun install --frozen-lockfile' \

hyperfine \
  --export-json=benchmark-package-install-ci-hot-analytics.json \
  --warmup=2 \
  --time-unit=millisecond \
  'cd website-node-20/analytics && yarn install --immutable' \
  'cd website-bunbuns/analytics && bun install --frozen-lockfile' \
