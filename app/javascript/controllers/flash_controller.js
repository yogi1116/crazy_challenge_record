import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  dismiss(event) {
    event.target.closest("[data-controller='flash']").remove();
  }
}