class User < ActiveRecord::Base

  def self.find_or_create(hash)
    user = where(provider: hash.provider, uid: hash.uid).first_or_create
    user.update(
        name: hash.info.name,
        profile_image: hash.info.image,
        token: hash.credentials.token,
        secret: hash.credentials.secret
    )
    user
  end
end
