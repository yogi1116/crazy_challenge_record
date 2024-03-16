import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="submit-button"
export default class extends Controller {
  static targets = ["submit", "textArea", "input"]

  connect() {
    this.toggle()
  }

  toggle() {
    const inputFiles = this.hasInputTarget ? this.inputTarget.files.length : 0;
    const hasContent = this.textAreaTarget.value.trim() !== '' || inputFiles > 0;
    this.submitTarget.classList.toggle('bg-lime-400', hasContent);
    this.submitTarget.classList.toggle('bg-gray-400', !hasContent);
    this.submitTarget.disabled = !hasContent;
  }

  resetForm() {
    // テキストエリアとファイル入力をクリア
    this.textAreaTarget.value = '';
    if (this.hasInputTarget) {
      this.inputTarget.value = '';
    }
    // ボタンの状態を更新
    this.toggle();
  }

  submitEnd() {
    // フォーム送信後のリセット処理を呼び出し
    this.resetForm();
  }
}
