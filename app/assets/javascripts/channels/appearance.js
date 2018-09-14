App.cable.subscriptions.create("AppearanceChannel", {
  // we need to use the "function" syntax because we want to avoid overwriting
  // this function's bounded `this` context
  connected: function() {
    this.perform('appear');
  },
  disconnected: function() {
    this.perform('away');
  },
  received: function(data) {
    $('#partners-list').html(data.html);
  },
});
