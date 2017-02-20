// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap/bootstrap-tooltip
//= require jquery-ui
//= require unobtrusive_flash
//= require unobtrusive_flash_ui
//= require admin
//= require_tree ./autoload
//= require materialize
//= require autocomplete-rails





UnobtrusiveFlash.flashOptions['timeout'] = 45000; // milliseconds

$(function(){
  $("a[rel='tooltip']").tooltip();


});



$(document).ready(function() {
    $('select').material_select();
    $(".button-collapse").sideNav();
    $('.modal').modal();
    $('input.autocomplete').autocomplete({
        data: {
            "Apple": null,
            "Microsoft": null,
            "Google": 'http://placehold.it/250x250'
        },
        limit: 20, // The max amount of results that can be shown at once. Default: Infinity.
    });



});



/*$(function () {
	$("input").on('change keyup', 'input')filter(function() {
	    return this.value;
	}).addClass("not-empty");
});*/