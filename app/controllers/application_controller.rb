class ApplicationController < ActionController::Base
  include Api

  protect_from_forgery with: :exception

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def client
    @client ||= Client.new({token: @current_user.token, secret: @current_user.secret }) if current_user
  end

  helper_method :current_user, :client
end
