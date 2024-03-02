import consumer from "./consumer"

document.addEventListener("turbo:load", () => {
  const receiverIdElement = document.querySelector('[data-receiver-id]');
  const receiverId = receiverIdElement ? receiverIdElement.getAttribute('data-receiver-id') : null;
  console.log(receiverId);
  consumer.subscriptions.create({ channel: "ChatChannel", receiver_id: receiverId }, {
    connected() {
      console.log("チャンネルを接続しました");
    },

    disconnected() {
      console.log("チャンネルを切断しました");
    },

    received(data) {
      if (data.message) {
        const messages = document.getElementById('messages');
        messages.innerHTML += `<p>${data.message.body}</p>`;
      }

      if (data.error) {
        alert(data.error);
      }
    },

    // メッセージ送信用のメソッド
    send_message: function(message) {
      return this.perform('send_message', { message: message });
    }
  });
});