import "unpoly/unpoly.js";

import "../up_compiler/all.js";

// configure Unpoly to replace the whole body by default instead of just the main tag
up.fragment.config.mainTargets = ["body"];

// config links for Unpoly
up.link.config.followSelectors.push("a[href]");
up.link.config.preloadSelectors.push("a[href]");

// config forms for Unpoly
up.form.config.submitSelectors.push("form");
up.link.config.instantSelectors.push("a[href]");

// disable/enable logs for Unpoly
up.log.enable();
up.fragment.config.autoFocus = "keep";

// configure progress bar to appear after 500ms delay
up.network.config.lateDelay = 200;

// show global loading spinner during any network request
up.on("up:network:late", function () {
  const spinner = document.getElementById("global-loading-spinner");
  if (spinner) {
    spinner.classList.remove("hidden");
  }
});

up.on("up:network:recover", function () {
  const spinner = document.getElementById("global-loading-spinner");
  if (spinner) {
    spinner.classList.add("hidden");
  }
});

// keep Unpoly progress bar enabled (shown at top of page after 500ms)
