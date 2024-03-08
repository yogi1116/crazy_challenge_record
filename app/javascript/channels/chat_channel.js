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
      const messages = document.getElementById('messages');
      messages.insertAdjacentHTML('beforeend', data['message']);
      console.log(data)

      messages.scrollTop = messages.scrollHeight;
    }
  }
);