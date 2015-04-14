import {Socket} from "../vendor/phoenix";

export default function(cb) {
  let socket = new Socket('/ws');
  socket.connect();
  socket.join('notifications', {}).receive('ok', chan => {
    chan.on('project:update', cb);
  });
}
