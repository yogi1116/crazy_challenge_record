import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="image-preview"
export default class extends Controller {
  static targets = ["preview", "input"]

  previewImage() {
    const input = this.inputTarget
    const file = input.files[0]
    if (file) {
      const reader = new FileReader()
      reader.onload = (event) => {
        this.previewTarget.src = event.target.result
      }
      reader.readAsDataURL(file)
    }
  }
}
