# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
	subscriptionForm = $("#new_subscription")
	modalContent = subscriptionForm.closest('.modal-content')

	subscriptionForm.submit(
		(event)->
			event.preventDefault()
			$.post(
				subscriptionForm.attr('action'), 
				subscriptionForm.serializeArray(), 
				(data)->
					if data.success
						modalContent.html('You have been signed up for notifications.')
					else
						modalContent.find('#modal-error').html('There was an error - please try again.')
				).fail(->
					modalContent.find('#modal-error').html('There was an error - please try again.')
				)
			)