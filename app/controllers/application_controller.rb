class ApplicationController < ActionController::Base
  protect_from_forgery

  layout :layout

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  private

  def layout
   if controller_name == 'registrations' && action_name == 'edit'
      'home'
    else
      'application'
    end
  end
end
