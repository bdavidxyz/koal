/* eslint-env node */
import {JSDOM} from "jsdom"

export function createWindow(html) {
  const dom = new JSDOM(html)
  global.window = dom.window
  global.document = dom.window.document
  global.MutationObserver = dom.window.MutationObserver
  global.KeyboardEvent = dom.window.KeyboardEvent
  global.MouseEvent = dom.window.MouseEvent
  global.Element = dom.window.Element
  global.Node = dom.window.Node
  global.Event = dom.window.Event
  return global.window
}
