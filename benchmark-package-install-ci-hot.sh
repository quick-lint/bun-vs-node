#!/usr/bin/env bash
set -e
set -u
set -o pipefail

hyperfine \
  --export-json=benchmark-package-install-ci-hot-website.json \
  --warmup=2 \
  --time-unit=millisecond \
  --command-name='Yarn (website)' 'cd website-node-20 && yarn install --immutable' \
  --command-name='Bun (website)' 'cd website-bunbuns && bun install --frozen-lockfile' \

hyperfine \
  --export-json=benchmark-package-install-ci-hot-analytics.json \
  --warmup=2 \
  --time-unit=millisecond \
  --command-name='Yarn (analytics)' 'cd website-node-20/analytics && yarn install --immutable' \
  --command-name='Bun (analytics)' 'cd website-bunbuns/analytics && bun install --frozen-lockfile' \
