#!/usr/bin/env bash
set -e
set -u
set -o pipefail

hyperfine \
  --export-json=benchmark-package-install-ci-download-website.json \
  --warmup=1 \
  --time-unit=millisecond \
  --command-name='Yarn (website)' --prepare='rm -rf ~/.cache/yarn/ ~/Library/Caches/Yarn/v6/ website-node-20/node_modules/' 'cd website-node-20 && yarn install --immutable' \
  --command-name='Bun (website)' --prepare='rm -rf ~/.bun/install/cache/ website-bunbuns/node_modules/' 'cd website-bunbuns && bun install --frozen-lockfile' \

hyperfine \
  --export-json=benchmark-package-install-ci-download-analytics.json \
  --warmup=1 \
  --time-unit=millisecond \
  --command-name='Yarn (analytics)' --prepare='rm -rf ~/.cache/yarn/ ~/Library/Caches/Yarn/v6/ website-node-20/analytics/node_modules/' 'cd website-node-20/analytics && yarn install --immutable' \
  --command-name='Bun (analytics)' --prepare='rm -rf ~/.bun/install/cache/ website-bunbuns/analytics/node_modules/' 'cd website-bunbuns/analytics && bun install --frozen-lockfile' \
