// https://www.webrtc-experiment.com/text-chat/

var roomid = location.href.split('/rooms/')[1];
var connection = new DataConnection();

// connection.userid = prompt('Enter your username') || 'Anonymous';

// on data connection opens
connection.onopen = function(e) {
    document.getElementById('chat-input').disabled = false;
    useridBox.disabled = false;

    appendDIV('Data connection opened between you and ' + e.userid, e.userid);
};

// on text message or data object received
connection.onmessage = function(message, userid) {
    console.debug(userid, 'says', message);
    appendDIV(message, userid);
};

// on data connection error
connection.onerror = function(e) {
    console.debug('Error in data connection. Target user id', e.userid, 'Error', e);
};

// on data connection close
connection.onclose = function(e) {
    console.debug('Data connection closed. Target user id', e.userid, 'Error', e);
};

/* custom signaling gateway
connection.openSignalingChannel = function(callback) {
return io.connect().on('message', callback);
};
*/


// using firebase for signaling
connection.firebase = 'myrtc';

// if someone leaves; just remove his video
connection.onuserleft = function(userid) {
   appendDIV(userid + ' Left.', userid);
};

// check pre-created data connections
connection.check(roomid);

// setup new data connection
connection.setup(roomid);

var chatOutput = document.getElementById('chat-output');

function getTime() {
    var d = new Date();
    var time = d.getHours() + ":" + d.getMinutes() + ":" + d.getSeconds();
    return time; 
}

function appendDIV(data, userid) {
    var div = document.createElement('div');
    div.innerHTML = '<span class="user-id" style="font-weight:bold" contenteditable title="Use his user-id to send him direct messages or throw out of the room!">' + userid + '</span>' + ' [' + getTime() + ']: '
        + '<span class="message" contenteditable>' + data + '</span>';

    chatOutput.insertBefore(div, chatOutput.firstChild);
    div.tabIndex = 0;
    div.focus();

    chatInput.focus();
}

var chatInput = document.getElementById('chat-input');
chatInput.onkeypress = function(e) {
    if (e.keyCode !== 13 || !this.value) return;

    connection.send(this.value);
    appendDIV(this.value, 'anonymous-23');

    this.value = '';
    this.focus();
};
