import consumer from "./consumer"

consumer.subscriptions.create({ channel: "ChatChannel", conversation_id: conversationId }, {
  connected() {
    console.log("チャンネルに接続しました");
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
  }
});
