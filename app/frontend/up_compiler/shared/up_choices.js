import Choices from "choices.js";

up.compiler(".up_choices", function (element, data) {
  console.log("data", data);

  const selector = new Choices(element, {
    placeholder: true,
    placeholderValue: "Blog tags",
    removeItemButton: true,
    choices: data.allItems.map((e) => {
      let res = { value: e.name, label: e.name };
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
