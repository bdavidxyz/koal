import Choices from "choices.js";

up.compiler(".up_choices_tags", function (element, data) {
  // Default options for tag management
  const defaultOptions = {
    allowHTML: false,
    addItems: true,
    removeItemButton: true,
    duplicateItemsAllowed: false,
    editItems: false,
    addItemFilter: (value) => {
      // Only allow non-empty values and trim whitespace
      return !!value && value.trim().length > 0;
    },
    placeholder: true,
    placeholderValue: "Add tags...",
    searchPlaceholderValue: "Search or add tags",
    addItemText: (value) => `Press Enter to add tag "<b>${value}</b>"`,
    removeItemIconText: () => "Remove tag",
    removeItemLabelText: (value) => `Remove tag: ${value}`,
    itemSelectText: "",
    classNames: {
      containerOuter: ["choices"],
      containerInner: ["choices__inner"],
      input: ["choices__input"],
      inputCloned: ["choices__input--cloned"],
      list: ["choices__list"],
      listItems: ["choices__list--multiple"],
      listSingle: ["choices__list--single"],
      listDropdown: ["choices__list--dropdown"],
      item: ["choices__item"],
      itemSelectable: ["choices__item--selectable"],
      itemDisabled: ["choices__item--disabled"],
      itemChoice: ["choices__item--choice"],
      placeholder: ["choices__placeholder"],
      group: ["choices__group"],
      groupHeading: ["choices__heading"],
      button: ["choices__button"],
      activeState: ["is-active"],
      focusState: ["is-focused"],
      openState: ["is-open"],
      disabledState: ["is-disabled"],
      highlightedState: ["is-highlighted"],
      selectedState: ["is-selected"],
      flippedState: ["is-flipped"],
      loadingState: ["is-loading"],
      notice: ["choices__notice"],
      addChoice: ["choices__item--selectable", "add-choice"],
      noResults: ["has-no-results"],
      noChoices: ["has-no-choices"],
    },
  };

  // Merge default options with any custom options from data attributes
  const options = { ...defaultOptions, ...data };

  console.log(data);

  // Initialize Choices.js
  const choices = new Choices(element, options);
  // If there's a data-load-url, fetch existing tags
  if (data["load-url"]) {
    fetch(data["load-url"])
      .then((response) => response.json())
      .then((tags) => {
        const choiceOptions = tags.map((tag) => ({
          value: tag.name,
          label: tag.name,
          selected: false,
        }));
        choices.setChoices(choiceOptions, "value", "label", false);
      })
      .catch((error) => {
        console.warn("Failed to load tags:", error);
      });
  }

  // If there are selected tags (for edit mode), set them
  if (data["selected-tags"] && Array.isArray(data["selected-tags"])) {
    choices.setValue(data["selected-tags"]);
  }

  // Handle form submission - ensure the underlying select/input is properly updated
  const form = element.closest("form");
  if (form) {
    form.addEventListener("submit", function () {
      // Choices.js should automatically update the underlying element
      // but we can force it if needed
      const selectedValues = choices.getValue(true);
      element.value = selectedValues;
    });
  }

  // Store the Choices instance on the element for potential later access
  element._choicesInstance = choices;

  // Cleanup function - return a function to clean up when element is destroyed
  return function () {
    if (choices && typeof choices.destroy === "function") {
      choices.destroy();
    }
  };
});
