import Choices from "choices.js";

up.compiler(".up_choices", function (element, data) {
  const selector = new Choices(element, {
    placeholder: true,
    placeholderValue: "Blog tags",
    removeItemButton: true,
    classNames: {
      containerOuter: ["choices", "w-full", "!mt-2"],
      containerInner: [
        "choices__inner",
        "!bg-white",
        "!pt-2",
        "!pb-0",
        "!border-blue-200",
        "hover:!border-blue-300",
        "focus-within:!border-blue-400",
        "focus-within:!shadow-sm",
        "focus-within:!shadow-blue-100",
        "!rounded-lg",
      ],
      item: [
        "choices__item",
        "!text-blue-800",
        "!bg-blue-50",
        "!border",
        "!border-blue-200",
        "hover:!bg-blue-100",
        "hover:!border-blue-300",
        "!rounded-md",
        "!transition-colors",
      ],
      itemChoice: ["choices__item--choice", "!border-0", "!rounded-none"],
      button: [
        "choices__button",
        "!text-blue-600",
        "hover:!text-blue-800",
        "!border-none",
        "!bg-[url(data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjEiIGhlaWdodD0iMjEiIHZpZXdCb3g9IjAgMCAyMSAyMSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48ZyBmaWxsPSIjMjU2M2ViIiBmaWxsLXJ1bGU9ImV2ZW5vZGQiPjxwYXRoIGQ9Ik0yLjU5Mi4wNDRsMTguMzY0IDE4LjM2NC0yLjU0OCAyLjU0OEwuMDQ0IDIuNTkyeiIvPjxwYXRoIGQ9Ik0wIDE4LjM2NEwxOC4zNjQgMGwyLjU0OCAyLjU0OEwyLjU0OCAyMC45MTJ6Ii8+PC9nPjwvc3ZnPg==)]",
        "!transition-colors",
      ],
    },
    choices: data.allItems.map((e) => {
      let res = { value: e.id, label: e.name };
      if (data?.selItems?.length > 0) {
        if (data.selItems.find((selItem) => e.id === selItem.id)) {
          res["selected"] = true;
        }
      }
      return res;
    }),
  });

  return () => {
    selector.destroy();
  };
});
