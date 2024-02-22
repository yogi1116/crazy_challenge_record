import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="infinite-scroll"
export default class extends Controller {
  static targets = ["container"]

  connect() {
    this.loadMore()
  }

  loadMore() {
    window.addEventListener('scroll', () => {
      if (window.scrollY + window.innerHeight > document.body.offsetHeight - 100) { // 100px はトリガーとなる閾値
        let lastMessage = this.containerTarget.lastElementChild
        let lastMessageId = lastMessage.dataset.messageId

        fetch(`/your_endpoint?last_message_id=${lastMessageId}`, {
          headers: {
            'Accept': 'text/vnd.turbo-stream.html',
          },
        })
        .then(response => response.text())
        .then(html => Turbo.renderStreamMessage(html))
      }
    }, { passive: true })
  }
}


