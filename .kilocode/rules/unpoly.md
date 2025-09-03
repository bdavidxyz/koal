# unpoly.md

These are the rule to use UnpolyJS, whose documentation can be found through Context7 MCP. Their Github repo is https://github.com/unpoly/unpoly

## Guidelines

- Do not use anything like `document.addEventListener("DOMContentLoaded", function () {` in order to declare an Unpoly file.
- Always start an Unpoly file by `up.compiler(".up_toast", function (element, data) {`. It means "each time the given selector appears in the DOM, call the callback".
- See `app/frontend/up_compiler/shared/up_toast.js` if you are unsure about the syntax
