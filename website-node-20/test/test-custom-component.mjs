// Copyright (C) 2020  Matthew "strager" Glazar
// See end of file for extended copyright information.

import assert from "node:assert/strict";
import { describe, it } from "node:test";
import { substituteCustomHTMLComponentsAsync } from "../src/custom-component.mjs";

describe("custom HTML component", () => {
  describe("changes nothing if no components are registered", () => {
    for (let testHTML of [
      "hello",
      "<img src='banana.png'>",
      "<img src='banana.png' />",
      "<h1>hello</h1>",
      "<!DOCTYPE html>",
      "<!-- hello world -->",
    ]) {
      it(testHTML, async () => {
        assert.equal(
          await substituteCustomHTMLComponentsAsync(testHTML, {}),
          testHTML
        );
      });
    }
  });

  it("self-closing component with no attributes returns HTML", async () => {
    let components = {
      "x-hello": () => {
        return "<h1>hello, world</h1>";
      },
    };
    assert.equal(
      await substituteCustomHTMLComponentsAsync("<x-hello/>", components),
      "<h1>hello, world</h1>"
    );
  });

  it("not substituted recursively", async () => {
    let components = {
      "x-hello": () => {
        return "<x-hello>gottem</x-hello>";
      },
    };
    assert.equal(
      await substituteCustomHTMLComponentsAsync("<x-hello/>", components),
      "<x-hello>gottem</x-hello>"
    );
  });

  it("attributes", async () => {
    let components = {
      "x-example": (attributes) => {
        assert.ok("a" in attributes);
        assert.equal(attributes.b, "");
        assert.equal(attributes.c, "value");
        return "";
      },
    };
    await substituteCustomHTMLComponentsAsync(
      "<x-example a b='' c='value' />",
      components
    );
  });

  it("multiple instances of one component", async () => {
    let components = {
      "x-example": (attributes) => {
        return `[${attributes.id}]`;
      },
    };
    assert.equal(
      await substituteCustomHTMLComponentsAsync(
        "<x-example id=a /> then <x-example id=b />",
        components
      ),
      "[a] then [b]"
    );
  });

  it("children are not supported", async () => {
    let components = {
      "x-example": () => {
        return "";
      },
    };
    await assert.rejects(() =>
      substituteCustomHTMLComponentsAsync(
        "<x-example>child</x-example>",
        components
      )
    );
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
