import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.style.backgroundImage = "url('<%= image_path('post.jpeg') %>')";
    this.element.style.backgroundPosition = 'center';
    this.element.style.backgroundRepeat = 'no-repeat';
    this.element.style.backgroundAttachment = 'fixed';
  }
}