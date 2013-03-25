class ReceiveTextController < ActionController::Base
  skip_before_filter :verify_authenticity_token
  respond_to :json

  def create
    message_body = params["Body"]
    from_number = params["From"]
    to_number = params["To"]
  end
end