# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('#subscription_found_since').datepicker({maxDate: new Date});

  $('.pet-icon').click(->
  	# mark icon active
  	$('.pet-icon').removeClass('active')
  	$(this).addClass('active')

  	petForm = $('#temp_new_subscription')
  	# set species in form
  	species = $(this).data('species')
  	petForm.find('#subscription_species').val(species)
  	
  	# toggle form
  	petForm.find('#hidden-form').removeClass('collapse')

  	# enable submit
  	petForm.find(':submit').removeAttr('disabled')
  	)

$(document).ready(ready);
$(document).on('page:load', ready);