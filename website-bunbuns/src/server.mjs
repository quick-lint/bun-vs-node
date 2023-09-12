// Copyright (C) 2020  Matthew "strager" Glazar
// See end of file for extended copyright information.

import assert from "assert";
import colors from "@colors/colors/safe.js";
import {
  IndexConflictVFSError,
  MalformedDirectoryURIError,
  ServerConfigVFSFile,
  VFS,
  VFSDirectory,
} from "./vfs.mjs";
import { performance } from "perf_hooks";

export function makeServer({ wwwRootPath }) {
  let vfs = new VFS(wwwRootPath);
  return serve;

  function serve(request) {
    let beginTime = performance.now();
    return serveAsync(request)
      .catch((error) => {
        console.error(`error processing request: ${error.stack}`);
        if (error instanceof MalformedDirectoryURIError) {
          return new Response("", {
            status: 404, // TODO(strager): Should this be 400 instead?
          });
        }

        return new Response(error.stack, {
          status: 500,
        });
      })
      .then((response) => {
        let endTime = performance.now();
        logRequestResponse(request, response, beginTime, endTime);
        return response;
      });
  }

  async function serveAsync(request) {
    if (request.method !== "GET" && request.method !== "HEAD") {
      return new Response(`bad method ${request.method}`, {
        status: 405,
      });
    }
    let url = new URL(request.url);

    let requestPath = url.pathname.match(/^[^?]+/)[0];
    let pathLastSlashIndex = requestPath.lastIndexOf("/");
    assert.notStrictEqual(pathLastSlashIndex, -1);
    let childName = requestPath.slice(pathLastSlashIndex + 1);
    let directoryURI = requestPath.slice(0, pathLastSlashIndex + 1);

    let listing = await vfs.listDirectoryAsync(directoryURI);
    let entry = listing.get(childName);
    if (entry === null || entry instanceof VFSDirectory) {
      return new Response("", {
        status: 404,
      });
    } else if (entry instanceof ServerConfigVFSFile) {
      return new Response("", {
        status: 403,
      });
    } else if (entry instanceof IndexConflictVFSError) {
      return new Response("", {
        status: 409,
      });
    } else {
      let headers = { "content-type": entry.getContentType() };
      let data = undefined;
      if (request.method === "GET") {
        data = await entry.getContentsAsync();
      }
      return new Response(data, {
        status: 200,
        headers: headers,
      });
    }
  }
}

let statusToColor = {
  // Key is the range; 2 means 200-299.
  2: colors.green,
  3: colors.cyan,
  4: colors.yellow,
  5: colors.red,
};

function logRequestResponse(request, response, beginTime, endTime) {
  let durationMilliseconds = endTime - beginTime;
  let statusColor =
    statusToColor[Math.floor(response.status / 100)] ?? colors.red;
  console.log(
    `${request.method} ${new URL(request.url).pathname} ${statusColor(
      response.status
    )} ${durationMilliseconds.toFixed(2)} ms`
  );
}

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
