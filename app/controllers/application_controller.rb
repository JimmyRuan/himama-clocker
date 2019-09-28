class ApplicationController < ActionController::Base
  protected

  def after_sign_in_path_for(resource)
    new_clock_path
  end
end
