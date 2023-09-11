# bun-vs-node

This repository contains quick-lint-js's website and analytics tooling ported to
different runtimes:

| directory | runtime | package manager | test framework | notes                                                                                |
|-----------|---------|-----------------|----------------|--------------------------------------------------------------------------------------|
| `website` | Node.js | Yarn            | Jasmine        | original website as of quick-lint-js commit cc7c44e1c5e04313b6e278cdd82c31c13df681b0 |
| `node-20` | Node.js | Yarn            | node --test    |                                                                                      |
| `bunnode` | Bun     | Yarn            | bun test       | mostly uses Node.js APIs                                                             |
