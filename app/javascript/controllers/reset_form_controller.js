import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="reset-form"
export default class extends Controller {
  connect() {
    this.element.addEventListener("turbo:submit-end", (event) => {
      if (event.detail.success) {
        // フォームのリセット
        this.element.reset();
        // テキストエリアを明示的に空にする
        this.clearTextArea();
      }
    });
  }

  clearTextArea() {
    const textArea = this.element.querySelector('textarea');
    if (textArea) {
      textArea.value = '';
    }
  }
}

