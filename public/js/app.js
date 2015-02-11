function fetch_data(customer_uuid) {
    $(document).ready(function() {

        var socket = io.connect('https://plug.coinsetter.com:3000');

        socket.on('connect', function (data) {
            socket.emit('last room', '');
        	socket.emit('orders room', customer_uuid);
        });

        socket.on('last', function (data) {
            var now = new Date().toISOString();
            $('#timestamp').html('Updated: ' + $.timeago(now) + ', Last trade: ' + $.timeago(data.timeStamp));
            $('#price').html('Price: $<span id="price-value">' + data.price + '</span>');
            document.title = data.price;
        });
        
        socket.on('orders-' + customer_uuid, function (data){
            
            var btc = parseFloat($('#btc-amount').text()),
                usd = parseFloat($('#usd-amount').text()),
                price = parseFloat($('#price-value').text());
            
            if(data.side == 'BUY') {
                btc += data.filledQuantity;
                usd -= data.filledQuantity*price*1.0025;
            } else {
                btc -= data.filledQuantity;
                usd += data.filledQuantity*price/1.0025;
            }
            
            $('#btc-amount').text(Math.round(100*btc)/100);
            $('#usd-amount').text(Math.round(100*usd)/100);
            
            if(btc < 0.01) {
                $('#sell-btc').removeClass('btn-danger').addClass('btn-default disabled');
            } else {
                $('#sell-btc').removeClass('btn-default disabled').addClass('btn-danger');
            }
            
            if(usd < 1) {
                $('#buy-btc').removeClass('btn-success').addClass('btn-default disabled');
            } else {
                $('#buy-btc').removeClass('btn-default disabled').addClass('btn-danger');
            }
            
            $('#app-status').append("<span id='order-confirmation' class='alert alert-success'>Order Confirmed</span>");
            $('#order-confirmation').fadeOut(5000, function() { $(this).remove(); });
        });
    });

}

function login_to_coinsetter(url) {
    $('#login-to-coinsetter').attr('disabled', 'disabled');
    $('#login-to-coinsetter').html("<i id='login-icon' class='fa fa-spinner fa-spin'></i> Logging in ...");
    $.ajax({ url: url, dataType: 'SCRIPT', type: 'GET' });
}

function get_account_data(url) {
    $('#get-account-data').attr('disabled', 'disabled');
    $('#get-account-data').html("<i id='account-icon' class='fa fa-spinner fa-spin'></i> Getting data ...");
    $.ajax({ url: url, dataType: 'SCRIPT', type: 'GET' });
}

function buy(amount)  {
    var btcAmount = parseFloat(amount/$('#price-value').text()),
        actualBuy = Math.floor(100*(btcAmount)/1.0025)/100,
        url = '/buy/' + actualBuy + '/for/' + $('#price-value').text();
    
    $.ajax({ url: url, dataType: 'SCRIPT', type: 'GET' });
}

function sell(amount)  {
    var actualSell = Math.floor(100*amount/1.0025)/100,
        url = '/sell/' + actualSell + '/for/' + $('#price-value').text();
    
    $.ajax({ url: url, dataType: 'SCRIPT', type: 'GET' });
}