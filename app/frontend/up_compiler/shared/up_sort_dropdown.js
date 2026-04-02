up.compiler(".up_sort_dropdown", function (element) {
  const button = element.querySelector("[data-sort-toggle]");
  const menu = element.querySelector("[data-sort-menu]");
  const hideBtn = element.querySelector("[data-sort-hide]");

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

  const hideColumn = () => {
    const th = element.closest("th");
    if (!th) return;
    const index = Array.from(th.parentElement.children).indexOf(th);
    th.style.display = "none";
    th.closest("table")
      .querySelectorAll(`tbody tr td:nth-child(${index + 1})`)
      .forEach((td) => {
        td.style.display = "none";
      });
    menu.classList.add("hidden");
  };

  button.addEventListener("click", toggle);
  document.addEventListener("click", closeOnOutside);
  if (hideBtn) hideBtn.addEventListener("click", hideColumn);

  return () => {
    button.removeEventListener("click", toggle);
    document.removeEventListener("click", closeOnOutside);
    if (hideBtn) hideBtn.removeEventListener("click", hideColumn);
  };
});
