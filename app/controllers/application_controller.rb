class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  helper_method :time_diff, :display_duration, :display_time

  before_action :configure_permitted_parameters, if: :devise_controller?

  def time_diff(start_time, end_time)
    seconds_diff = (start_time - end_time).to_i.abs
    Time.at(seconds_diff).utc.strftime("%H:%M:%S")
  end

  def display_duration(start_time, end_time)
    unless start_time and end_time
      return 'N/A'
    end

    time_diff(start_time, end_time)
  end

  def display_time(time)
    time ? time.strftime('%Y/%m/%d %l:%M %p') : 'N/A'
  end

  protected

    def after_sign_in_path_for(resource)
      new_clock_path
    end

    # def configure_permitted_parameters
    #   devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password) }
    #   devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :current_password) }
    # end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    end


end
