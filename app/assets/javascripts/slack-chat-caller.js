$(document).ready(function() {
  var slackChatOptions;
  $('.message-box > a').slackChat('destroy');
  $('.message-box');
  $('[data-toggle=tooltip]').tooltip();
  $('.message-box > a').slackChat('destroy');
  $('.message-box').hide();
  slackChatOptions = {
    apiToken: gon.global.slack_chat_token,
    channelId: gon.global.slack_chat_channel_id,
    user: user_name,
    userLink: user_link,
    userId: user_id,
    msgUserId: user_id,
    userImg: "data: image/png;base64,"+ (new Identicon('d3b07384d113edec49eaa6238ad5ff01', 40).toString()),
    defaultUserImg: gon.global.slack_chat_user_img,
    defaultSysImg: gon.global.slack_chat_default_sys_img,
    defaultSysUser: 'Equipe Gadz.org',
    chatBoxHeader: gon.global.slack_chat_chat_box_header,
    botUser: 'ChatSupport - '+gon.global.slack_chat_app_name,
    elementToDisable: $('.message-box'),
    disableIfAway: false,
    webCache: false,
    debug: false,
    privateChannel: false,
    heightOffset: 150,
    messageFetchCount: 25
  };
  $('.message-box > a').slackChat(slackChatOptions);
  return $('.message-box').show();
});