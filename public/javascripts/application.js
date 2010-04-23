js = {
  vk: {
    init: function() {
      VK.init({
        apiId: '1864632',
        nameTransportPath: '/xd_receiver.htm'
      });
    },

    on_login_button_click: function() {
      VK.Auth.login(function(response) {
        if (response.session) {
          // save uid, session to server
          VK.Api.call('getVariable', {'key': '1280'}, function(r){
            alert('sid: ' + response.session.sid + ', uid: ' + r.response)
          });
        }
      });
    },

    on_logout_button_click: function(url) {
      VK.Auth.logout(function() {
        window.location = url;
      });
    },
    
    on_login: function() {
      VK.Observer.subscribe('auth.login', function(response) {
        $('#vk_user_loggedout').hide();

        // crappy username call
        VK.Api.call('getVariable', {'key': '1281'}, function(r){
          $('#vk_username').html(r.response);
          $('#vk_user_loggedin').show();
        });
      });
    }
    
  }
}
