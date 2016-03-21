$(document).ready(function() {
	// hach to swap label and input order
	// $('input').each(function() {
 //  		$(this).insertBefore( $(this).prev('label') );
	// });
/*	$('input').each(function() {
		var a = $(this).parent()
  		if($(a[0]).attr('class') != "group") {
			alert("fff")
		}
  		
	});*/

	// check if inputs are empty
	$('input').each(function () {
		if($(this).val() != '') {
			$(this).addClass( 'notempty')
		}
	});

	$('input').focus(function () {
		$(this).addClass( 'notempty');
			console.log($(this));

	});

	$('input').blur(function () {
		if($(this).val() == '') {
			$(this).removeClass('notempty');
		}
		
	});
});