import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="post-preview"
export default class extends Controller {
  static targets = ["input", "imageBox"]

  connect() {
    this.previewPost()
  }

  previewPost() {
    const input = this.inputTarget;
    const files = input.files;
    const previewContainer = this.imageBoxTarget;
    previewContainer.innerHTML = '';

    if (files) {
      Array.from(files).forEach((file) => {
        const reader = new FileReader();
        reader.onload = (event) => {
          const imgElement = document.createElement('img');
          imgElement.src = event.target.result;
          imgElement.classList.add('w-40', 'h-40', 'object-cover'); // スタイルを適用するクラスを追加
          previewContainer.appendChild(imgElement);
        };
        reader.readAsDataURL(file);
      });
    }
  }
}