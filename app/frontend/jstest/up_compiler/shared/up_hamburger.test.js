/* eslint-env node */
import { test } from "node:test";
import assert from "node:assert/strict";
import { createWindow } from "../../helpers.js";

let compiledFn;
globalThis.up = { compiler: (_selector, fn) => { compiledFn = fn; } };
await import("../../../up_compiler/shared/up_hamburger.js");

const HTML = `
  <div id="container">
    <div id="menu-icon">
      <svg id="hamburger"></svg>
      <svg id="close" class="hidden"></svg>
    </div>
    <div id="menu" class="hidden"></div>
  </div>
`;

test("up_hamburger shows menu and swaps icons on first click", () => {
  const win = createWindow(HTML);
  const element = win.document.querySelector("#container");
  compiledFn(element);

  const menuIcon = element.querySelector("#menu-icon");
  const menu = element.querySelector("#menu");
  const hamburgerIcon = menuIcon.querySelector("svg:nth-child(1)");
  const closeIcon = menuIcon.querySelector("svg:nth-child(2)");

  menuIcon.dispatchEvent(new win.MouseEvent("click"));

  assert.equal(menu.classList.contains("hidden"), false, "menu should be visible after click");
  assert.equal(hamburgerIcon.classList.contains("hidden"), true, "hamburger icon should be hidden after click");
  assert.equal(closeIcon.classList.contains("hidden"), false, "close icon should be visible after click");
});

test("up_hamburger hides menu and restores icons on second click", () => {
  const win = createWindow(HTML);
  const element = win.document.querySelector("#container");
  compiledFn(element);

  const menuIcon = element.querySelector("#menu-icon");
  const menu = element.querySelector("#menu");
  const hamburgerIcon = menuIcon.querySelector("svg:nth-child(1)");
  const closeIcon = menuIcon.querySelector("svg:nth-child(2)");

  menuIcon.dispatchEvent(new win.MouseEvent("click"));
  menuIcon.dispatchEvent(new win.MouseEvent("click"));

  assert.equal(menu.classList.contains("hidden"), true, "menu should be hidden after second click");
  assert.equal(hamburgerIcon.classList.contains("hidden"), false, "hamburger icon should be visible again");
  assert.equal(closeIcon.classList.contains("hidden"), true, "close icon should be hidden again");
});

test("up_hamburger cleanup removes click listener", () => {
  const win = createWindow(HTML);
  const element = win.document.querySelector("#container");
  const cleanup = compiledFn(element);

  const menuIcon = element.querySelector("#menu-icon");
  const menu = element.querySelector("#menu");

  cleanup();

  menuIcon.dispatchEvent(new win.MouseEvent("click"));

  assert.equal(menu.classList.contains("hidden"), true, "menu should remain hidden after cleanup");
});
