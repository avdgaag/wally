import {Socket} from "../vendor/phoenix";

export default function(cb) {
  let socket = new Socket('/ws');
  socket.connect();
  let channel = socket.chan('notifications', {});
  channel.on('project:update', cb);
  channel.join().receive('ok', chan => {
    console.log('Subscribed to wall updates');
  });
}
