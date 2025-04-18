import "unpoly/unpoly.js";

import "../up_compiler/all.js";

// config links for Unpoly
up.link.config.followSelectors.push("a[href]");
up.link.config.preloadSelectors.push("a[href]");

// config forms for Unpoly
up.form.config.submitSelectors.push("form");
up.link.config.instantSelectors.push("a[href]");

// disable/enable logs for Unpoly
up.log.disable();
