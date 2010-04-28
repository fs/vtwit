js = {
  vk: {
    init: function() {
      VK.init({
        apiId: '1864632',
        nameTransportPath: '/xd_receiver.htm'
      });
    },

    on_login_button_click: function() {
      VK.Auth.login();
    },

    on_logout_button_click: function(callback_url) {
      VK.Auth.logout(function() {
        $.post(callback_url)
        location.reload();
      });
    },
    
    on_login: function(callback_url) {
      VK.Observer.subscribe('auth.login', function(response) {
        $('#vk_user_loggedout').hide();

        code = 'return {';
        code += 'uid: API.getVariable({key: 1280}),';
        code += 'username: API.getVariable({key: 1281})';
        code += '};';

        VK.Api.call('execute', {'code': code}, function(r){
          $('#vk_username').html(r.response.username);
          $('#vk_user_loggedin').show();

          $.post(callback_url, {
            sid: response.session.sid,
            uid: r.response.uid,
            username: r.response.username
           });
        });
      });
    }
    
  }
}
