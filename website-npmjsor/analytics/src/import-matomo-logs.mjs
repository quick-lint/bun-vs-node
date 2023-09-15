#!/usr/bin/env node
// Copyright (C) 2020  Matthew "strager" Glazar
// See end of file for extended copyright information.

import { AnalyticsDB } from "./analytics-db.mjs";
import { loadConfigAsync } from "./config.mjs";
import { MatomoAnalyticsDB } from "./matomo-analytics-db.mjs";

async function mainAsync(args) {
  let config = await loadConfigAsync();
  let matomoDB = await MatomoAnalyticsDB.fromConfigAsync(config);
  let db = AnalyticsDB.fromFile(config["db.file"]);

  let importedDownloads = 0;
  function saveDownloads(downloads) {
    db.addWebDownloadBatch(downloads);
    importedDownloads += downloads.length;
  }
  await db.batchAsync(async () => {
    await matomoDB.enumerateDownloadsAsync(saveDownloads);
  });
  console.log(`imported ${importedDownloads} downloads from Matomo`);

  matomoDB.close();
  db.close();
}

mainAsync(process.argv.slice(2)).catch((e) => {
  console.error(e?.stack || e);
  process.exit(1);
});

// quick-lint-js finds bugs in JavaScript programs.
// Copyright (C) 2020  Matthew "strager" Glazar
//
// This file is part of quick-lint-js.
//
// quick-lint-js is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// quick-lint-js is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with quick-lint-js.  If not, see <https://www.gnu.org/licenses/>.
