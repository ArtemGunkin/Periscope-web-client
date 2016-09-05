class SessionsController < ApplicationController

  def create
    twitter = User.find_or_create(auth_hash)
    session[:user_id] = twitter.id
    redirect_to profile_url
  end

  def destroy
    reset_session
    redirect_to root_path
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
