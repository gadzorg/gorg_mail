/**
 * Created by alexandre on 26/09/16.
 */
$( document ).ready(function() {

    $('.subscribe_ml_button').click( function (event) {
        console.log(event);
        ga('send', 'event', 'MailingList', 'hit_subscribe');
    });

    $('#not_joined_lists').on('DOMNodeInserted', 'div', function(e) {
        console.log(e);
        $('.subscribe_ml_button').click( function (event) {
            ga('send', 'event', 'MailingList', 'hit_subscribe');
        });
    });

    $('.unsubscribe_ml_button').click( function (event) {
        console.log(event);
        ga('send', 'event', 'MailingList', 'hit_unsubscribe');
    });

    $('#joined_lists').on('DOMNodeInserted', 'div', function(e) {
        console.log(e);
        $('.unsubscribe_ml_button').click( function (event) {
            ga('send', 'event', 'MailingList', 'hit_unsubscribe');
        });
    });


});