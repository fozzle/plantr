class ReceiveTextController < ActionController::Base
  skip_before_filter :verify_authenticity_token

  def create
    message_body = params["Body"]
    from_number = params["From"]
    to_number = params["To"]

    @twilio_client = Twilio::REST::Client.new ENV["TWILIO_SID"], ENV["TWILIO_TOKEN"]
 
    garden = Garden.where(:phone => to_number).first
    
    unless garden.nil?
      from_user = garden.users.find_by_phone(from_number)

      unless from_user.nil?
        garden.users.each do |user|
          next if user.phone.nil? or user == from_user

          @twilio_client.account.sms.messages.create(
            :from => "#{to_number}",
            :to => "#{user.phone}",
            :body => "#{from_user.username}: " + message_body
          )
        end
      end
    end

    respond_to do |format|
      format.json { render :status => :ok }
    end
  end
end