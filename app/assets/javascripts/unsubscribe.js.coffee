jQuery ->
	form = $('form#unsubscribe-form')

	form.submit((event)-> 
		event.preventDefault()

		$.post(
			form.attr('action'),
			form.serializeArray(),
			(data)-> 
				if (data.success) 
					form.find('#email_or_phone').val('You have been unsubscribed.')
				else 
					alert('There was an error - please try again.')
			)
	)