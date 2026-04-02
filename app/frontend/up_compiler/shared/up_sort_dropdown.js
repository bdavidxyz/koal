up.compiler(".up_sort_dropdown", function (element) {
  const button = element.querySelector("[data-sort-toggle]");
  const menu = element.querySelector("[data-sort-menu]");

  const toggle = (e) => {
    e.preventDefault();
    e.stopPropagation();
    menu.classList.toggle("hidden");
  };

  const closeOnOutside = (e) => {
    if (!element.contains(e.target)) {
      menu.classList.add("hidden");
    }
  };

  button.addEventListener("click", toggle);
  document.addEventListener("click", closeOnOutside);

  return () => {
    button.removeEventListener("click", toggle);
    document.removeEventListener("click", closeOnOutside);
  };
});
