function fetch_data() {
    $(document).ready(function() {

        var socket = io.connect('https://plug.coinsetter.com:3000');

        socket.on('connect', function (data) {
        	socket.emit('last room', '');
        });

        socket.on('last', function (data) {
            var now = new Date().toISOString();
            $('#timestamp').html('Updated: ' + $.timeago(now) + ', Last trade: ' + $.timeago(data.timeStamp));
            $('#price').html('Price: $' + data.price);
            document.title = data.price;
        });
    });
}

function login_to_coinsetter(url) {
    $('#login-to-coinsetter').attr('disabled', 'disabled');
    $('#login-to-coinsetter').html("<i id='login-icon' class='fa fa-spinner fa-spin'></i> Logging in ...");
    $.ajax({ url: url, dataType: 'SCRIPT', type: 'GET' });
}

function j(string) {
    var entityMap = { "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': '&quot;', "'": '&#39;', "/": '&#x2F;' };

    return String(string).replace(/[&<>"'\/]/g, function (s) {
        return entityMap[s];
    });
}