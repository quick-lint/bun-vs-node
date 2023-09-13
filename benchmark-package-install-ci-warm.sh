#!/usr/bin/env bash
set -e
set -u
set -o pipefail

clear_fs_cache='echo 3 | sudo tee /proc/sys/vm/drop_caches'
warm_yarn_package_cache='find ~/.cache/yarn/ -type f -exec cat "{}" \+ >/dev/null'
warm_bun_package_cache='find ~/.bun/install/cache/ -type f -exec cat "{}" \+ >/dev/null'

hyperfine \
  --export-json=benchmark-package-install-ci-warm-website.json \
  --warmup=2 \
  --time-unit=millisecond \
  --command-name='Yarn (website)' --prepare="rm -rf website-node-20/node_modules/ && ${clear_fs_cache} && ${warm_yarn_package_cache}" 'cd website-node-20 && yarn install --immutable' \
  --command-name='Bun (website)' --prepare="rm -rf website-bunbuns/node_modules/ && ${clear_fs_cache} && ${warm_bun_package_cache}" 'cd website-bunbuns && bun install --frozen-lockfile' \

hyperfine \
  --export-json=benchmark-package-install-ci-warm-analytics.json \
  --warmup=2 \
  --time-unit=millisecond \
  --command-name='Yarn (analytics)' --prepare="rm -rf website-node-20/analytics/node_modules/ && ${clear_fs_cache} && ${warm_yarn_package_cache}" 'cd website-node-20/analytics && yarn install --immutable' \
  --command-name='Bun (analytics)' --prepare="rm -rf website-bunbuns/analytics/node_modules/ && ${clear_fs_cache} && ${warm_bun_package_cache}" 'cd website-bunbuns/analytics && bun install --frozen-lockfile' \
