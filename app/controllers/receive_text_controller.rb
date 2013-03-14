class ReceiveTextController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
  	twilio_sid = "AC3d33aec0094782093e058f29c5093856"
    twilio_token = "c7151b10ee5ad0318135974ad31e8cae"
    
    message_body = params["Body"]
    from_number = params["From"]
    to_number = params["To"]

    @twilio_client = Twilio::REST::Client.new twilio_sid, twilio_token
 
    garden = Garden.where(:phone => to_number).first
    garden.users.each do |user|
    	next if user.phone.nil?

      @twilio_client.account.sms.messages.create(
        :from => "+1#{to_number}",
        :to => "#{user.phone}",
        :body => message_body
      )
    end
  end
end