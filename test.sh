#!/usr/bin/env bash
set -e
set -o pipefail
set -u

(
    printf '===== testing website-node-14 =====\n'
    cd website-node-14
    yarn install --force
    (cd analytics && yarn install --force)
    yarn test
    rm -rf www/
    yarn build
)

(
    printf '===== testing website-node-20 =====\n'
    cd website-node-20
    yarn install --force
    (cd analytics && yarn install --force)
    yarn test
    rm -rf www/
    yarn build
)
diff -r website-node-14/www/ website-node-20/www/

(
    printf '===== testing website-bunnode =====\n'
    cd website-bunnode
    yarn install --force
    (cd analytics && yarn install --force)
    bun test
    rm -rf www/
    bun run build
)
diff -r website-node-14/www/ website-bunnode/www/
