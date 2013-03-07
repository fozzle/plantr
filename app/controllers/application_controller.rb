class ApplicationController < ActionController::Base
  protect_from_forgery

  layout :layout

  private

  def layout
   if controller_name == 'registrations' && action_name == 'edit'
      'home'
    else
      'application'
    end
  end
end
