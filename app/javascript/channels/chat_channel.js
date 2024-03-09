import consumer from "channels/consumer"

const receiver_id_element = document.querySelector('[data-receiver-id]');
const receiver_id = receiver_id_element.getAttribute('data-receiver-id');

consumer.subscriptions.create(
  { channel: "ChatChannel", receiver_id: receiver_id },
  {
    connected() {
      console.log("チャンネルを接続しました");
    },
    disconnected() {
      console.log("チャンネルを切断しました");
    },

    received(data) {
      if (data.error) {
        const errorMessagesContainer = document.getElementById('error-messages');
        errorMessagesContainer.innerHTML = data.error;
      } else {
        const currentUserId = document.body.dataset.userId; // current_userのidをbodyタグから取得
        const isCurrentUser = Number(data.current_user_id) === Number(currentUserId); // サーバーサイドとクライアントサイドのcurrent_userを比較
        const messagesContainer = document.getElementById('messages'); // 過去のメッセージ一覧

        const messageElement = document.createElement('div'); // 新規メッセージ
        messageElement.innerHTML = data.message; // 受け取ったデータを_message.htmlに当てはめる

        if (isCurrentUser) {
          // メッセージを送信したユーザーが現在のユーザーの場合
          messageElement.classList.add('message-sent');
        } else {
          // メッセージを送信したユーザーが他のユーザーの場合
          messageElement.classList.add('message-received');
        }

        // メッセージをページに挿入
        messagesContainer.appendChild(messageElement);
        messagesContainer.scrollTop = messagesContainer.scrollHeight;
      }
    }
  }
);