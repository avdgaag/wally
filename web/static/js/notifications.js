import {Socket} from "../vendor/phoenix";

export default function(cb) {
  let socket = new Socket('/ws');
  socket.connect();
  let channel = socket.chan('notifications', { api_token: window.API_TOKEN });
  channel.on('project:update', cb);
  channel.join().receive('ok', ({message}) => {
    console.info('Subscribed to wall updates');
  }).receive('error', ({reason}) => {
    console.error('Could not subscribe to wall updates:', reason);
  });
}
