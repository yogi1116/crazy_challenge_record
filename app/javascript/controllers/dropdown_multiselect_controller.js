import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dropdown-multiselect"
export default class extends Controller {
  static targets = ["dropdown", "hiddenField", "dropdownMenu", "selectedItems"]

  connect() {
    console.log("DropdownMultiSelect controller connected");
    this.selectedValues = [];
  }

  toggleDropdownMenu() {
    this.dropdownMenuTarget.classList.toggle('hidden');
  }

  select(event) {
    event.preventDefault();
    const name = event.target.innerText;
    const value = event.target.dataset.value;

    // 既に選択されている項目をチェック
    if (!this.selectedValues.includes(value)) {
      this.selectedValues.push(value);

      // 選択された項目を表示エリアに追加
      const selectedItem = document.createElement("span");
      selectedItem.textContent = name;
      selectedItem.classList.add("selected-item", "bg-gray-200", "rounded-full", "px-2", "py-1", "text-sm", "mr-2");
      this.selectedItemsTarget.appendChild(selectedItem);

      // 隠しフィールドに選択されたカテゴリーIDを格納
      this.hiddenFieldTarget.value = this.selectedValues.join(',');
    }

    // ドロップダウンメニューを閉じる
    this.toggleDropdownMenu();
  }
}