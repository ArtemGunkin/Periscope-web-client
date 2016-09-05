module Api
  class Client
    include HTTParty
    attr_reader :secret, :key, :id, :username, :display_name, :cookie, :image_path,
                :followers, :following, :hearts, :description

    base_uri 'https://api.periscope.tv/api/v2'
    format :json

    def initialize (args)
      if args[:cookie]
        @cookie = args[:cookie]
      else
        login(args[:token], args[:secret])
      end
    end

    def about
      user = request('/user', {body: {user_id: @id}})['user']
      @hearts = user['n_hearts']
      self
    end

    def user_info(id)
      request('/user', {body: {user_id: id}})['user']
    end

    def login(token, secret)
      response = request('/loginTwitter', {body: {session_key: token, session_secret: secret, }})
      user = response['user']

      @cookie = response['cookie']
      @key, @secret = token, secret
      @id, @username, @display_name = user['id'], user['username'], user['display_name']
      @description = user['description']
      @image_path = user['profile_image_urls'][1]['url']
      @followers = user['n_followers']
      @following = user['n_following']
    end

    def validate_username(token, secret)
      request('/validateUsername', {body: {session_key: token, session_secret: secret}})
    end

    # Registration user after login with twitter
    def verify_username(*options)
      request('/verifyUsername', {body: {
          session_key: options[0],
          session_secret: options[1],
          username: options[2],
          display_name: options[3]
      }})
    end

    # mapGeoBroadcastFeed
    def map_broad_feed(replay, *coords)
      request('/mapGeoBroadcastFeed', {body: {
          include_replay: replay,
          p1_lat: coords[0],
          p1_lng: coords[1],
          p2_lat: coords[2],
          p2_lng: coords[3]
      }})
    end

    # Broadcasts from users that are being followed by the current user.
    def following_broadcast_feed
      request('/followingBroadcastFeed', {body: {}})
    end

    def ranked_broadcast_feed(langs)
      request('/rankedBroadcastFeed', {body: {languages: langs}})
    end

    # Search broadcasts by title
    def broadcast_search(options)
      request('/broadcastSearch', {body: {query: options[0], search: options[1], include_replay: options[2]}})
    end

    def access_video(id)
      request('/accessVideo', {body: {broadcast_id: id}})
    end

    def access_chat(token)
      request('/accessChat', {body: {chat_token: token}})
    end

    def get_broadcast_viewers(id)
      request('/getBroadcastViewers', {body: {broadcast_id: id}})
    end

    def get_broadcasts(ids)
      request('/getBroadcasts', {body: {broadcast_ids: ids}})
    end

    def ping_watching(id, options)
      request('/pingWatching', {body: {
          broadcast_id: id, session: options[0], n_commsents: options[1], n_hearts: options[2]}})
    end

    def stop_watching(id, *options)
      request('/stopWatching', {body: {
          broadcast_id: id, session: options[0], n_commsents: options[1], n_hearts: options[2]}})
    end

    def mark_abuse(id)
      request('/markAbuse', {body: {broadcast_id: id}})
    end

    # Update user description
    def update_description(desc)
      request('/updateDescription', {body: {description: desc}})
    end

    # Update display name
    def update_name(name)
      request('/updateDisplayName', {body: {display_name: name}})
    end

    # People suggested to user
    def suggested_people(lang)
      request('/suggestedPeople', {body: {languages: lang}})
    end

    # User search
    def user_search(query)
      request('/userSearch', {body: {search: query}})
    end

    # Follow user
    def follow(id)
      request('/follow', {body: {user_id: id}})
    end

    # Unfollow user
    def unfollow(id)
      request('/unfollow', {body: {user_id: id}})
    end

    # Followers
    def user_followers(id)
      request('/followers', {body: {user_id: id}})
    end

    # Following
    def user_following(id)
      request('/following', {body: {user_id: id}})
    end

    # Broadcasts
    def user_broadcasts(id)
      request('/userBroadcasts', {body: {user_id: id, all: true}})
    end

    # Block user
    def block_add(id)
      request('/block/add', {body: {to: id}})
    end

    # Unblock user
    def block_remove(id)
      request('/block/remove', {body: {to: id}})
    end

    # Get the list of blocked users
    def block_users
      request('/block/users', {body: {}})
    end

    private

    # Basic request method
    def request(url, options)
      options[:headers] = {
          'User-Agent' => 'tv.periscope.ios',
          'Content-type' => 'application/json'
      }
      options[:body][:cookie] = @cookie
      options[:body] = options[:body].to_json
      # req = options[:body]
      self.class.post(url, options).parsed_response
    end
  end
end
