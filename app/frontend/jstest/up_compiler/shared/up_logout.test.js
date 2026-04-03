/* eslint-env node */
import {test} from "node:test"
import assert from "node:assert/strict"
import {createWindow} from "../../helpers.js"
import {up_logout} from "../../../up_compiler/shared/up_logout.js"

test("up_logout changes cursor style, removes class, updates label text and color on click", () => {
  const win = createWindow(`
    <div id="logout">
      <button class="cursor-pointer">
        <span class="logout-label">Logout</span>
      </button>
    </div>
  `)

  const button = win.document.querySelector("#logout button")

  up_logout(button)

  button.dispatchEvent(new win.Event("click"))

  assert.equal(button.style.cursor, "default", "cursor should be set to default after click")
  assert.equal(button.classList.contains("cursor-pointer"), false, "cursor-pointer class should be removed after click")
  assert.equal(button.querySelector(".logout-label").textContent, "please wait...", "label text should change to 'please wait...' after click")
  assert.equal(button.querySelector(".logout-label").style.color, "lightgray", "label color should be lightgray after click")
})

test("up_logout does not change anything before click", () => {
  const win = createWindow(`
    <div id="logout">
      <button class="cursor-pointer">
        <span class="logout-label">Logout</span>
      </button>
    </div>
  `)

  const button = win.document.querySelector("#logout button")

  up_logout(button)

  assert.equal(button.style.cursor, "", "cursor should not change before click")
  assert.equal(button.classList.contains("cursor-pointer"), true, "cursor-pointer class should remain before click")
  assert.equal(button.querySelector(".logout-label").textContent, "Logout", "label text should remain unchanged before click")
})

test("up_logout cleanup removes the click event listener", () => {
  const win = createWindow(`
    <div id="logout">
      <button class="cursor-pointer">
        <span class="logout-label">Logout</span>
      </button>
    </div>
  `)

  const button = win.document.querySelector("#logout button")

  const cleanup = up_logout(button)

  cleanup()

  button.dispatchEvent(new win.Event("click"))

  assert.equal(button.style.cursor, "", "cursor should not change after cleanup")
  assert.equal(button.classList.contains("cursor-pointer"), true, "cursor-pointer class should remain after cleanup")
  assert.equal(button.querySelector(".logout-label").textContent, "Logout", "label text should remain unchanged after cleanup")
})
