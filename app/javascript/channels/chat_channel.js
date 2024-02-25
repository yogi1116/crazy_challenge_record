import consumer from "./consumer"

// メッセージ送信用の関数を追加
consumer.subscriptions.create({ channel: "ChatChannel", conversation_id: conversationId }, {
  connected() {
    console.log("Conversation ID:", this.conversation_id);
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

// 送信ボタンクリックイベントにメッセージ送信機能を組み込む
document.getElementById('send_button').addEventListener('click', function() {
  var message = document.getElementById('message_input').value;
  // ここでメッセージを送信
  consumer.subscriptions.subscriptions[0].send_message(message);
});
