up.compiler("#logout button", function (element) {
  function handleClick() {
    element.style.cursor = "default";
    element.classList.remove("cursor-pointer");
    element.querySelector(".logout-label").textContent = "please wait...";
    element.querySelector(".logout-label").style.color = "lightgray";
  }

  element.addEventListener("click", handleClick);

  return () => {
    element.removeEventListener("click", handleClick);
  };
});
