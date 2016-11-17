
// Allows you to send data to dart services
function transmit(type, content) {
    var event = new CustomEvent('PUMP_' + type, { 'detail': content });
    document.dispatchEvent(event);
}

var Service = function(channels, callback) {
  this.channels = channels;
  this.callback = callback;
  this.enabled = true;
  
  var self = this;
  channels.forEach( function(channel) {
    document.addEventListener('PUMP_' + channel.toString(), function(event) {
      if (self.enabled) {
        self.callback(event.detail);
      }
    });
  });
}