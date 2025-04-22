up.compiler(".up_hamburger", function (element, data) {
  const menuIcon = element.querySelector("#menu-icon");
  const menu = element.querySelector("#menu");
  const hamburgerIcon = menuIcon.querySelector("svg:nth-child(1)");
  const closeIcon = menuIcon.querySelector("svg:nth-child(2)");

  const blockClicked = () => {
    menu.classList.toggle("hidden");
    hamburgerIcon.classList.toggle("hidden");
    closeIcon.classList.toggle("hidden");
  };

  menuIcon.addEventListener("click", blockClicked);
  return () => {
    menuIcon.removeEventListener("click", blockClicked);
  };
});
