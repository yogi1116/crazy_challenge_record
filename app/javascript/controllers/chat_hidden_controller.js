import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="chat-hidden"
export default class extends Controller {
  static targets = ["info"]

  connect() {
    document.addEventListener("turbo:submit-end", () => {
      this.hideInfo();
    });
  }

  hideInfo() {
    this.infoTargets.forEach((target) => {
      target.classList.add("hidden");
    });
  }
}
