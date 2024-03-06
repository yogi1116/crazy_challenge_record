import consumer from "channels/consumer"

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
        const messagesContainer = document.getElementById('messages');

        // メッセージコンテナを作成
        const messageElement = document.createElement('div');
        messageElement.classList.add('col-start-1', 'col-end-11', 'rounded-lg', 'm-1', 'flex', 'flex-row', 'items-center');

        // アバター画像（もし前のメッセージと時刻が異なるなら表示）
        // このロジックはクライアントサイドでは簡単には実装できないため、例として省略または常に表示するようにします
        const avatarElement = document.createElement('img');
        avatarElement.src = data.message.sender_avatar_url;
        avatarElement.classList.add('flex', 'items-center', 'justify-center', 'h-10', 'w-10', 'rounded-full', 'flex-shrink-0');
        messageElement.appendChild(avatarElement);

        // メッセージ本文または画像
        if (data.message.image_url) {
          const imageElement = document.createElement('img');
          imageElement.src = data.message.image_url;
          imageElement.classList.add('w-48', 'h-48', 'm-1');
          messageElement.appendChild(imageElement);
        } else {
          const textElement = document.createElement('div');
          textElement.textContent = data.message.body;
          textElement.classList.add('relative', 'ml-3', 'text-sm', 'bg-white', 'py-2', 'px-4', 'shadow', 'rounded-xl', 'break-all');
          messageElement.appendChild(textElement);
        }

        // 時刻表示
        const timeElement = document.createElement('div');
        timeElement.textContent = data.message.sent_at;
        timeElement.classList.add('text-xs', 'ml-1', 'text-gray-500', 'mt-auto');
        messageElement.appendChild(timeElement);

        // messagesContainerの末尾にメッセージを追加
        messagesContainer.appendChild(messageElement);

        // スクロールを最下部に移動
        messagesContainer.scrollTop = messagesContainer.scrollHeight;
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