// Copyright (C) 2020  Matthew "strager" Glazar
// See end of file for extended copyright information.

import { describe, it, expect } from "bun:test";
import { releasesMarkdownToHTML } from "../src/release-documentation.mjs";

describe("release documentation releasesMarkdownToHTML", () => {
  it("removes title", () => {
    let html = releasesMarkdownToHTML("# titlegoeshere\nbodygoeshere");
    expect(html).not.toContain("titlegoeshere");
    expect(html).toContain("bodygoeshere");
  });

  it("## heading is <h3>", () => {
    let html = releasesMarkdownToHTML("## heading3\nbodygoeshere");
    expect(html).toContain("<h2>");
    expect(html).not.toContain("<h1>");
    expect(html).not.toContain("<h3>");
  });

  it("### heading is <h3>", () => {
    let html = releasesMarkdownToHTML("### heading4\nbodygoeshere");
    expect(html).toContain("<h3>");
    expect(html).not.toContain("<h2>");
    expect(html).not.toContain("<h4>");
  });

  it("#### heading is <h4>", () => {
    let html = releasesMarkdownToHTML("#### heading5\nbodygoeshere");
    expect(html).toContain("<h4>");
    expect(html).not.toContain("<h3>");
    expect(html).not.toContain("<h5>");
  });

  it("linkifies versioned heading", () => {
    let html = releasesMarkdownToHTML("## 2.15.0 (2023-07-18)\n\nhello");
    expect(html).toContain('<h2 id="2.15.0">');
    expect(html).toContain('<a href="#2.15.0">2.15.0 (2023-07-18)</a>');
  });
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
