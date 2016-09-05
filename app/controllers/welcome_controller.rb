class WelcomeController < ApplicationController

  def index
    redirect_to profile_url if client
  end
end
