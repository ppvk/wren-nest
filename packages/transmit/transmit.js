
// Allows you to send data to dart services
function transmit(type, content) {
    var event = new CustomEvent('PUMP_' + type, { 'detail': content });
    document.dispatchEvent(event);
}

