import {Promise} from 'es6-promise';

function getJson(uri) {
  return new Promise(function(resolve, reject) {
    let xhr = new XMLHttpRequest();
    xhr.open('GET', encodeURI(uri));
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.onload = function() {
      if(xhr.status === 200) {
        resolve(JSON.parse(xhr.responseText));
      } else {
        reject(Error(xhr.responseText));
      }
    };
    xhr.onerror = function() {
      reject(Error('network error'));
    };
    xhr.send();
  });
}

export default getJson;
