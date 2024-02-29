import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="message-preview"
export default class extends Controller {
  static targets = ["input", "preview", "textArea"]

  previewImage() {
    const input = this.inputTarget
    const file = input.files[0]
    if (file) {
      const reader = new FileReader()
      reader.onload = (e) => {
        this.previewTarget.src = e.target.result
        this.previewTarget.classList.remove('hidden')
        // テキストエリアを非表示にする
        this.textAreaTarget.classList.add('hidden')
      }
      reader.readAsDataURL(file)
    }
  }

  clearPreview() {
    // プレビュー画像を初期状態に戻し、プレビューを非表示にする
    this.previewTarget.src = ''
    this.previewTarget.classList.add('hidden')
    // テキストエリアを再表示する
    this.textAreaTarget.classList.remove('hidden')
  }
}
