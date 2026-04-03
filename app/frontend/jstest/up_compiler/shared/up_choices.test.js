/* eslint-env node */
import { mock, test } from "node:test";
import assert from "node:assert/strict";
import { createWindow } from "../../helpers.js";

let capturedOptions;
let destroyCalled = false;

class MockChoices {
  constructor(_el, opts) {
    capturedOptions = opts;
    destroyCalled = false;
  }
  destroy() {
    destroyCalled = true;
  }
}

mock.module("choices.js", { defaultExport: MockChoices });

let compiledFn;
globalThis.up = { compiler: (_selector, fn) => { compiledFn = fn; } };
await import("../../../up_compiler/shared/up_choices.js");

test("up_choices maps allItems to choices with value and label", () => {
  const win = createWindow(`<select class="up_choices"></select>`);
  const element = win.document.querySelector(".up_choices");

  compiledFn(element, {
    placeholder: "Select...",
    allItems: [
      { id: 1, name: "Apple" },
      { id: 2, name: "Banana" },
    ],
    selItems: [],
  });

  assert.deepEqual(capturedOptions.choices, [
    { value: 1, label: "Apple" },
    { value: 2, label: "Banana" },
  ]);
});

test("up_choices marks items as selected when they appear in selItems", () => {
  const win = createWindow(`<select class="up_choices"></select>`);
  const element = win.document.querySelector(".up_choices");

  compiledFn(element, {
    placeholder: "Select...",
    allItems: [
      { id: 1, name: "Apple" },
      { id: 2, name: "Banana" },
      { id: 3, name: "Cherry" },
    ],
    selItems: [{ id: 2 }, { id: 3 }],
  });

  assert.deepEqual(capturedOptions.choices, [
    { value: 1, label: "Apple" },
    { value: 2, label: "Banana", selected: true },
    { value: 3, label: "Cherry", selected: true },
  ]);
});

test("up_choices does not mark items selected when selItems is empty", () => {
  const win = createWindow(`<select class="up_choices"></select>`);
  const element = win.document.querySelector(".up_choices");

  compiledFn(element, {
    placeholder: "Select...",
    allItems: [{ id: 1, name: "Apple" }],
    selItems: [],
  });

  assert.equal(capturedOptions.choices[0].selected, undefined, "item should not be marked selected");
});

test("up_choices does not mark items selected when selItems is absent", () => {
  const win = createWindow(`<select class="up_choices"></select>`);
  const element = win.document.querySelector(".up_choices");

  compiledFn(element, {
    placeholder: "Select...",
    allItems: [{ id: 1, name: "Apple" }],
  });

  assert.equal(capturedOptions.choices[0].selected, undefined, "item should not be marked selected when selItems is absent");
});

test("up_choices cleanup calls destroy on the Choices instance", () => {
  const win = createWindow(`<select class="up_choices"></select>`);
  const element = win.document.querySelector(".up_choices");

  const cleanup = compiledFn(element, {
    placeholder: "Select...",
    allItems: [{ id: 1, name: "Apple" }],
    selItems: [],
  });

  cleanup();

  assert.equal(destroyCalled, true, "destroy should be called on cleanup");
});
