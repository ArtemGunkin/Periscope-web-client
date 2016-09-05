class ProfileController < ApplicationController

  def home
    @about = client.about
    @broadcasts = []
    broadcast_data = client.following_broadcast_feed
    broadcast_data.each do |broadcast|
      @broadcasts.push(Broadcast.new(broadcast))
    end
  end

  def list
    @about = client.about
    @broadcasts = []
    broadcast_data = client.ranked_broadcast_feed(['ru'])
    broadcast_data.each do |broadcast|
      @broadcasts.push(Broadcast.new(broadcast))
    end
  end

  def show
    id = params[:id]
    @user = client.user_info(id)
  end
end
