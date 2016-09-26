/**
 * Created by alexandre on 26/09/16.
 */
$( document ).ready(function() {
    $('#new_email_redirect_account_submit').click( function (event) {
        ga('send', 'event', 'EmailRedirection', 'hit_add')
    });

    $('.era_del_button').click( function (event) {
        console.log(event);
        ga('send', 'event', 'EmailRedirection', 'hit_delete');
    });

    $('#era_list').on('DOMNodeInserted', 'li', function(e) {
        console.log(e);
        $('.era_del_button').click( function (event) {
            ga('send', 'event', 'EmailRedirection', 'hit_delete');
        });
    });

    $('#create_google_apps_button').click( function (event) {
        ga('send', 'event', 'GoogleApps', 'hit_dashboard_create_button')
    });

    $('#connect_to_google_button').click( function (event) {
        ga('send', 'event', 'GoogleApps', 'hit_connect_to_google_button')
    });

});