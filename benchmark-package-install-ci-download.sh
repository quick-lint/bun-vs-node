#!/usr/bin/env bash
set -e
set -u
set -o pipefail

hyperfine \
  --export-json=benchmark-package-install-ci-download-website.json \
  --warmup=1 \
  --time-unit=millisecond \
  --command-name='Yarn (website) (yarnpkg.com)' --prepare='rm -rf ~/.cache/yarn/ ~/Library/Caches/Yarn/v6/ website-node-20/node_modules/' 'cd website-node-20 && yarn install --immutable' \
  --command-name='Yarn (website) (npmjs.org)' --prepare='rm -rf ~/.cache/yarn/ ~/Library/Caches/Yarn/v6/ website-npmjsor/node_modules/' 'cd website-npmjsor && yarn install --immutable' \
  --command-name='Bun (website) (npmjs.org)' --prepare='rm -rf ~/.bun/install/cache/ website-bunbuns/node_modules/' 'cd website-bunbuns && bun install --frozen-lockfile' \

hyperfine \
  --export-json=benchmark-package-install-ci-download-analytics.json \
  --warmup=1 \
  --time-unit=millisecond \
  --command-name='Yarn (analytics) (yarnpkg.com)' --prepare='rm -rf ~/.cache/yarn/ ~/Library/Caches/Yarn/v6/ website-node-20/analytics/node_modules/' 'cd website-node-20/analytics && yarn install --immutable' \
  --command-name='Yarn (analytics) (npmjs.org)' --prepare='rm -rf ~/.cache/yarn/ ~/Library/Caches/Yarn/v6/ website-npmjsor/analytics/node_modules/' 'cd website-npmjsor/analytics && yarn install --immutable' \
  --command-name='Bun (analytics) (npmjs.org)' --prepare='rm -rf ~/.bun/install/cache/ website-bunbuns/analytics/node_modules/' 'cd website-bunbuns/analytics && bun install --frozen-lockfile' \
