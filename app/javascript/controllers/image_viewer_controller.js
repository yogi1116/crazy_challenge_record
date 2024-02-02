import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="image-viewer"
export default class extends Controller {
  static targets = ["image"]

  expand(event) {
    // 拡大表示するための処理
    const imageUrl = event.currentTarget.getAttribute('src');
    const viewer = document.createElement('div');
    viewer.innerHTML = `
      <div class="fixed inset-0 bg-black bg-opacity-50 z-50 flex justify-center items-center">
        <div class="bg-white p-5 rounded">
          <img src="${imageUrl}" class="max-h-[80vh] max-w-[80vw]"/>
          <button class="close-button absolute top-0 right-0 m-2 text-white bg-red-600 hover:bg-red-700 rounded-full px-3 py-1">✕</button>
        </div>
      </div>
    `;

    // viewer内のバツボタンを探し、クリックイベントを追加
    const closeButton = viewer.querySelector('.close-button');
    closeButton.addEventListener('click', () => {
      this.close();
    });

    document.body.appendChild(viewer);
  }

  close() {
    // 拡大表示を閉じるための処理
    document.body.removeChild(document.body.lastChild);
  }
}
