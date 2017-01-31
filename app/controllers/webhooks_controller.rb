class WebhooksController < ApplicationController
  protect_from_forgery :except => :webhook

  def webhook
    # Retrieve the request's body and parse it as JSON
    event_json = JSON.parse(request.body.read)

    # Retrieve the event from Stripe
    event = Stripe::Event.retrieve({ id: event_json['id'] },
    { stripe_account: event_json['user_id'] })

    # Only respond to `account.updated` events
    if event.type.eql?('account.updated')
      # Determine if identity verification is needed
      unless event.data.object.verification.fields_needed.nil?
        # Send a notification to the connected account
        message_params = {
            from: 'you@yourdomain.com', # Your domain or Mailgun Sandbox domain
            to: event.data.object.email, # Email address of the connected account
            subject: 'Please update your account information',
            text: 'Hi there! We need some additional information about your account
            to continue sending you transfers. You can get this to us by following
            the link here: https://yourdomain.com/account/submit_info'
           }
        result = mg_client.send_message('yourdomain.com', message_params).to_h!
      end
    else
      # Nothing to see here, return a 200
      status 200
    end

    if event.type.eql?('charge.created')
      message_params = {
          from: 'you@yourdomain.com', # Your domain or Mailgun Sandbox domain
          to: event.data.object.charge.receipt_email, # Email address of the connected account
          subject: 'Donation confirmation!',
          text: 'Thanks! Your donation is confirmed.'
         }
      result = mg_client.send_message('yourdomain.com', message_params).to_h!
    else
      # Nothing to see here, return a 200
      status 200
    end
  end
end
