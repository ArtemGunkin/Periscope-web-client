class BroadcastController < ApplicationController

  def index
    @response = client.access_video(params[:broadcast])
    @url = @response['hls_url']

    chat_token = @response['chat_token']
    chat_response= client.access_chat(chat_token)
    @chat_point = chat_response['endpoint']
    @room_id = chat_response['room_id']
    @access_token = chat_response['access_token']

    user_hash = client.user_info(@response['broadcast']['user_id'])
    @user = PeriscopeUser.new(user_hash)
  end
end
