/* eslint-env node */
import { mock, test } from "node:test";
import assert from "node:assert/strict";

let capturedOptions;
let showToastCalled = false;

const MockToastify = (opts) => {
  capturedOptions = opts;
  return {
    showToast: () => {
      showToastCalled = true;
    },
  };
};

const toastifyUrl = new URL("../../../custom_js/toastify.js", import.meta.url)
  .href;
mock.module(toastifyUrl, { defaultExport: MockToastify });

let compiledFn;
globalThis.up = {
  compiler: (_selector, fn) => {
    compiledFn = fn;
  },
};
await import("../../../up_compiler/shared/up_toast.js");

test("up_toast passes message as text to Toastify", () => {
  compiledFn({}, { msg: "Hello World!" });

  assert.equal(
    capturedOptions.text,
    "Hello World!",
    "msg should be passed as text",
  );
});

test("up_toast uses top gravity by default", () => {
  compiledFn({}, { msg: "Test" });

  assert.equal(capturedOptions.gravity, "top", "default gravity should be top");
});

test("up_toast uses bottom gravity when specified", () => {
  compiledFn({}, { msg: "Test", gravity: "bottom" });

  assert.equal(
    capturedOptions.gravity,
    "bottom",
    "gravity should be bottom when specified",
  );
});

test("up_toast uses custom bar background color when provided", () => {
  compiledFn({}, { msg: "Colored", color: "#ff0000" });

  assert.equal(
    capturedOptions.progressBarStyle.barBackground,
    "#ff0000",
    "should use custom color as bar background",
  );
});

test("up_toast defaults bar background color to white when color is not provided", () => {
  compiledFn({}, { msg: "Test" });

  assert.equal(
    capturedOptions.progressBarStyle.barBackground,
    "#ffffff",
    "default bar background should be white",
  );
});

test("up_toast calls showToast", () => {
  showToastCalled = false;
  compiledFn({}, { msg: "Test" });

  assert.equal(showToastCalled, true, "showToast should be called");
});
