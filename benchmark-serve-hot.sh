#!/usr/bin/env bash
set -e
set -u
set -o pipefail

(cd website-node-20 && yarn install)
(cd website-bunnode && yarn install)
(cd website-bunbuns && bun install)

hyperfine \
  --export-json=benchmark-serve-hot.json \
  --warmup=1 \
  --time-unit=millisecond \
  --command-name='Bun server (Bun APIs), Bun client' --prepare='cd website-bunbuns && ../start-server.sh bun --bun run run-server-worker.mjs' 'cd website-bunbuns && bun --bun run tools/check-links.mjs http://localhost:9001/' \
  --command-name='Bun server (Bun APIs), Node.js client (fetch)' --prepare='cd website-bunbuns && ../start-server.sh bun --bun run run-server-worker.mjs' 'cd website-node-20 && node tools/check-links.mjs http://localhost:9001/' \
  --command-name='Bun server (Bun APIs), Node.js client (node:http)' --prepare='cd website-bunbuns && ../start-server.sh bun --bun run run-server-worker.mjs' 'cd website-node-14 && node tools/check-links.mjs http://localhost:9001/' \
  --command-name='Bun server (Node.js APIs), Bun client' --prepare='cd website-bunnode && ../start-server.sh bun --bun run run-server-worker.mjs' 'cd website-bunbuns && bun --bun run tools/check-links.mjs http://localhost:9001/' \
  --command-name='Bun server (Node.js APIs), Node.js client (fetch)' --prepare='cd website-bunnode && ../start-server.sh bun --bun run run-server-worker.mjs' 'cd website-node-20 && node tools/check-links.mjs http://localhost:9001/' \
  --command-name='Bun server (Node.js APIs), Node.js client (node:http)' --prepare='cd website-bunnode && ../start-server.sh bun --bun run run-server-worker.mjs' 'cd website-node-14 && node tools/check-links.mjs http://localhost:9001/' \
  --command-name='Node.js server, Bun client' --prepare='cd website-node-20 && ../start-server.sh node run-server-worker.mjs' 'cd website-bunbuns && bun --bun run tools/check-links.mjs http://localhost:9001/' \
  --command-name='Node.js server, Node.js client (fetch)' --prepare='cd website-node-20 && ../start-server.sh node run-server-worker.mjs' 'cd website-node-20 && node tools/check-links.mjs http://localhost:9001/' \
  --command-name='Node.js server, Node.js client (node:http)' --prepare='cd website-node-20 && ../start-server.sh node run-server-worker.mjs' 'cd website-node-14 && node tools/check-links.mjs http://localhost:9001/' \
