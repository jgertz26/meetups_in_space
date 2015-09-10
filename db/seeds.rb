# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Example:
#
require 'faker'

Meetup.create(title: "Jews for Jesus", description: "Cuz Jews think Jesus was pretty rad, too.", location: "The Commons", date: "2015/12/24")
Meetup.create(title: "Boston Ruby Group", description: "Let's get together and compare rubies", location: "City Hall", date: "2015/10/02")
Meetup.create(title: "Scrabble night!", description: "We gon' get our scrabble on", location: "Bill's House", date: "2015/09/28")
Meetup.create(title: "Stevie Wonder Appreciation", description: "Gonna listen to some sick jamz", location: "Everywhere", date: "2015/11/23")


15.times do
  User.create(
  provider: "github",
  uid: Faker::Number.number(8),
  username: Faker::Internet.user_name,
  email: Faker::Internet.free_email,
  avatar_url: Faker::Avatar.image
  )
end

User.create(
 provider: "github",
 uid: "12990876",
 username: "jgertz26",
 email: "jgertz26@gmail.com",
 avatar_url: "https://avatars.githubusercontent.com/u/12990876?v=3"
)

meetups = Meetup.all
user = User.first

meetups.each do |meetup|
  MeetupUser.create(meetup: meetup, user: user)
end
