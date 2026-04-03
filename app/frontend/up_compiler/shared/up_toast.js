import Toastify from "../../custom_js/toastify.js";

up.compiler(".up_toast", function (element, data) {
  Toastify({
    text: data.msg,
    progressBar: true,
    progressBarStyle: {
      background: "#3f3f46",
      barBackground: data.color || "#ffffff",
      height: "4px",
    },
    progressBarPosition: "bottom",
    duration: 5000,
    close: true,
    gravity: data.gravity || "top",
    position: "center",
    stopOnFocus: true,
    offset: {
      y: "65px",
    },
  }).showToast();
});
