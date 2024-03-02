import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="infinite-scroll"
export default class extends Controller {
  static debouncedLoadMessages = null; // デバウンス用のタイマーIDを保持

  initialize() {
    this.loading = false;
    this.page = 1;
    this.debounceInterval = 200; // デバウンスの間隔（ミリ秒）
  }

  scroll() {
    // デバウンス処理
    clearTimeout(this.constructor.debouncedLoadMessages); // 既存のタイマーをクリア
    this.constructor.debouncedLoadMessages = setTimeout(() => {
      if (this.element.scrollTop < 100 && !this.loading) {
        this.loadMessages();
      }
    }, this.debounceInterval);
  }

  loadMessages() {
    if (this.loading) return;
    this.loading = true;

    fetch(`/messages?page=${this.page}`)
      .then(response => response.text())
      .then(data => {
        // メッセージの追加処理
        this.page += 1;
      })
      .catch(error => console.error("Error loading messages:", error))
      .finally(() => this.loading = false);
  }
}
