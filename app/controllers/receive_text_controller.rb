class ReceiveTextController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
    message_body = params["Body"]
    from_number = params["From"]
    to_number = params["To"]

    @twilio_client = Twilio::REST::Client.new ENV["TWILIO_SID"], ENV["TWILIO_TOKEN"]
 
    garden = Garden.where(:phone => to_number).first
    return if garden.nil?

    garden.users.each do |user|
    	next if user.phone.nil? or user.phone == from_number

      @twilio_client.account.sms.messages.create(
        :from => "+1#{to_number}",
        :to => "#{user.phone}",
        :body => message_body
      )
    end
  end
end