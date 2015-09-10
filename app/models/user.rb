class User < ActiveRecord::Base
  has_many :meetup_users
  has_many :meetups,
  through: :meetup_users

  validates_presence_of :provider, :uid, :email, :username, :avatar_url
  validates :provider, format: { with: /\Agithub\z/ }

  def self.find_or_create_from_omniauth(auth)
    provider = auth.provider
    uid = auth.uid

    find_by(provider: provider, uid: uid) || create_from_omniauth(auth)
  end

  def self.create_from_omniauth(auth)
    create(
      provider: auth.provider,
      uid: auth.uid,
      email: auth.info.email,
      username: auth.info.nickname,
      avatar_url: auth.info.image
    )
  end
end
