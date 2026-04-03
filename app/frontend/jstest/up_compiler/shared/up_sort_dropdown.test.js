/* eslint-env node */
import { test } from "node:test";
import assert from "node:assert/strict";
import { createWindow } from "../../helpers.js";

let compiledFn;
globalThis.up = {
  compiler: (_selector, fn) => {
    compiledFn = fn;
  },
};
await import("../../../up_compiler/shared/up_sort_dropdown.js");

test("up_sort_dropdown toggles menu visibility on button click", () => {
  const win = createWindow(`
    <div id="wrapper">
      <div id="container">
        <button data-sort-toggle>Sort</button>
        <div data-sort-menu class="hidden"></div>
      </div>
    </div>
  `);
  const element = win.document.querySelector("#container");
  compiledFn(element);

  const button = element.querySelector("[data-sort-toggle]");
  const menu = element.querySelector("[data-sort-menu]");

  assert.equal(
    menu.classList.contains("hidden"),
    true,
    "menu should start hidden",
  );

  button.dispatchEvent(new win.MouseEvent("click", { bubbles: true }));
  assert.equal(
    menu.classList.contains("hidden"),
    false,
    "menu should be visible after first click",
  );

  button.dispatchEvent(new win.MouseEvent("click", { bubbles: true }));
  assert.equal(
    menu.classList.contains("hidden"),
    true,
    "menu should be hidden after second click",
  );
});

test("up_sort_dropdown closes menu on click outside the element", () => {
  const win = createWindow(`
    <div id="wrapper">
      <div id="container">
        <button data-sort-toggle>Sort</button>
        <div data-sort-menu class="hidden"></div>
      </div>
      <div id="outside"></div>
    </div>
  `);
  const element = win.document.querySelector("#container");
  compiledFn(element);

  const button = element.querySelector("[data-sort-toggle]");
  const menu = element.querySelector("[data-sort-menu]");

  button.dispatchEvent(new win.MouseEvent("click", { bubbles: true }));
  assert.equal(
    menu.classList.contains("hidden"),
    false,
    "menu should be open after toggle click",
  );

  const outside = win.document.querySelector("#outside");
  outside.dispatchEvent(new win.MouseEvent("click", { bubbles: true }));
  assert.equal(
    menu.classList.contains("hidden"),
    true,
    "menu should close on outside click",
  );
});

test("up_sort_dropdown does not close menu on click inside the element", () => {
  const win = createWindow(`
    <div id="wrapper">
      <div id="container">
        <button data-sort-toggle>Sort</button>
        <div data-sort-menu class="hidden">
          <span id="inside">item</span>
        </div>
      </div>
    </div>
  `);
  const element = win.document.querySelector("#container");
  compiledFn(element);

  const button = element.querySelector("[data-sort-toggle]");
  const menu = element.querySelector("[data-sort-menu]");

  button.dispatchEvent(new win.MouseEvent("click", { bubbles: true }));
  assert.equal(menu.classList.contains("hidden"), false, "menu should be open");

  const inside = win.document.querySelector("#inside");
  inside.dispatchEvent(new win.MouseEvent("click", { bubbles: true }));
  assert.equal(
    menu.classList.contains("hidden"),
    false,
    "menu should remain open on inside click",
  );
});

test("up_sort_dropdown hide button hides the column and its cells", () => {
  const win = createWindow(`
    <table>
      <thead>
        <tr>
          <th>Name</th>
          <th id="target-th">
            <div id="container">
              <button data-sort-toggle>Sort</button>
              <div data-sort-menu class="hidden">
                <button data-sort-hide>Hide</button>
              </div>
            </div>
          </th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>Alice</td>
          <td id="target-td">Smith</td>
        </tr>
      </tbody>
    </table>
  `);
  const element = win.document.querySelector("#container");
  compiledFn(element);

  const hideBtn = element.querySelector("[data-sort-hide]");
  hideBtn.dispatchEvent(new win.MouseEvent("click", { bubbles: true }));

  const th = win.document.querySelector("#target-th");
  const td = win.document.querySelector("#target-td");

  assert.equal(th.style.display, "none", "th should be hidden");
  assert.equal(td.style.display, "none", "corresponding td should be hidden");
});

test("up_sort_dropdown cleanup removes button and document listeners", () => {
  const win = createWindow(`
    <div id="wrapper">
      <div id="container">
        <button data-sort-toggle>Sort</button>
        <div data-sort-menu class="hidden"></div>
      </div>
      <div id="outside"></div>
    </div>
  `);
  const element = win.document.querySelector("#container");
  const cleanup = compiledFn(element);

  const button = element.querySelector("[data-sort-toggle]");
  const menu = element.querySelector("[data-sort-menu]");

  cleanup();

  button.dispatchEvent(new win.MouseEvent("click", { bubbles: true }));
  assert.equal(
    menu.classList.contains("hidden"),
    true,
    "menu should remain hidden after cleanup",
  );
});
