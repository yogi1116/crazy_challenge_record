import consumer from "channels/consumer"

const receiverIdElement = document.querySelector('[data-receiver-id]');
const receiverId = receiverIdElement.getAttribute('data-receiver-id');

consumer.subscriptions.create(
  { channel: "ChatChannel", receiver_id: receiverId },
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
        const currentUserId = document.body.dataset.userId;
        const isSender = Number(data.sender_id) === Number(currentUserId);
        const messageHTML = buildMessageHTML(data, isSender);

        document.getElementById('messages').insertAdjacentHTML('beforeend', messageHTML);
        scrollToBottom();
      }
    }
  }
);

function buildMessageHTML(data, isSender) {
  const imageContent = buildImageContent(data, isSender);
  const avatarContent = buildAvatarContent(data, isSender);
  const timeContent = `<div class="text-xs ${isSender ? 'mr-1' : 'ml-1 mt-auto'} text-gray-500">${data.message_sent_at}</div>`;

  if (isSender) {
    return `
      <div class="col-start-5 md:col-start-3 col-end-13 rounded-lg">
        <div class="flex flex-row justify-end items-end" data-controller="image-viewer">
          ${timeContent}
          ${imageContent}
        </div>
      </div>`;
  } else {
    return `
      <div class="col-start-1 col-end-11 rounded-lg m-1">
        <div class="flex flex-row items-center" data-controller="image-viewer">
          ${avatarContent}
          ${imageContent}
          ${timeContent}
        </div>
      </div>`;
  }
}

function buildImageContent(data, isSender) {
  return data.message_image_url ?
    `<img src="${data.message_image_url}" class="w-48 h-48 m-1" data-action="click->image-viewer#expand">` :
    `<div class="relative text-sm bg-${isSender ? 'indigo-500' : 'white'} py-2 px-4 shadow rounded-xl ${isSender ? 'text-white' : ''} m-1 break-all">${data.message_body}</div>`;
}

let lastMessageTime = null;
function buildAvatarContent(data, isSender) {
  const isPreviousTime = data.message_sent_at === lastMessageTime;
  lastMessageTime = data.message_sent_at;

  if (!isSender && !isPreviousTime) {
    return `<img src="${data.sender_avatar_url}" class="flex items-center justify-center h-10 w-10 rounded-full flex-shrink-0">`;
  } else if (!isSender && isPreviousTime) {
    return `<div class="h-10 w-10 flex-shrink-0"></div>`;
  }
  return '';
}

function scrollToBottom() {
  const messagesContainer = document.getElementById('messages');
  messagesContainer.scrollTop = messagesContainer.scrollHeight;
}