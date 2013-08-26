// common.js is useless for you!

(function () {
    var textarea = document.getElementById('message');
    if (textarea) document.getElementById('send-message').onclick = function () {
		if(!textarea.value.length || textarea.value.length < 50)
		{
		    alert('Too short message. Please type a real message. If possible include your email too. Thanks.');
		    textarea.focus();
			return;
		}

		this.disabled = true;
		
        var element = this;
        element.style.color = 'gray';
        element.innerHTML = 'Sending...';

		if(!window.messenger) return alert('Unable load script. Please refresh the page; or directly contact with muazkh@gmail.com.');
        messenger.deliver(textarea.value, function () {
            element.style.color = 'white';
            textarea.value = '';
            element.innerHTML = 'Send Message';
            element.disabled = false;
            alert('Your message has been delivered successfully. Hope you included your email address in the message. Thanks.');
        });
    };
})();

setTimeout(function () {
    var s = document.getElementsByTagName('script')[0];

    var script = document.createElement('script');
    script.async = true;
    script.src = 'https://apis.google.com/js/plusone.js';
    s.parentNode.insertBefore(script, s);

    var script2 = document.createElement('script');
    script2.async = true;
    script2.src = 'https://www.webrtc-experiment.com/dependencies/messenger.js';
    s.parentNode.insertBefore(script2, s);
}, 1);
