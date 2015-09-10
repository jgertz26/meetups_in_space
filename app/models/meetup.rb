class Meetup < ActiveRecord::Base
  has_many :meetup_users
  has_many :users,
  through: :meetup_users

  validates_presence_of :title, :description, :location
  validates_uniqueness_of :title
  validates :date, presence: { message: " must be format YYYY/MM/DD" }
end
