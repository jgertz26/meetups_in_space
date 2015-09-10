require "spec_helper"

feature "User creates meetups", %(
As a user
I want to create a meetup
So that I can gather a group of people to discuss a given topic
) do

  background do
    Meetup.create(title: "Jews for Jesus", description: "Cuz Jews think Jesus was pretty rad, too.", location: "The Commons", date: "2015-12-24")
    Meetup.create(title: "Boston Ruby Group", description: "Let's get together and compare rubies", location: "City Hall", date: "2015-10-02")
    Meetup.create(title: "Scrabble night!", description: "We gon' get our scrabble on", location: "Bill's House", date: "2015-09-28")
    Meetup.create(title: "Stevie Wonder Appreciation", description: "Gonna listen to some sick jamz", location: "Everywhere", date: "2015-11-23")
  end

    scenario "user visits the index page" do
      visit '/'
      expect(page).to have_content("Upcoming Meetups:")
    end

    scenario "user sees meetups in alphabetical order" do
      visit '/'
      expect(first('.meetup')).to have_content "Boston Ruby Group"
    end

    scenario "user attempts to create a group without being signed in" do
      visit '/'
      fill_in 'title', with: "testyingggg"
      fill_in 'date', with: "2015/11/21"
      fill_in 'location', with: "the barn"
      fill_in 'description', with: "blarrrrggghhhhhh"
      click_button 'Submit'
      expect(page).to have_content("You need to sign in if you want to do that!")
    end

    scenario "user attempts to create a group without being signed in" do
      jim = User.create(
      provider: "github",
      uid: "24980753",
      username: "jimlovesjimlovesjim",
      email: "jim@jimmail.com",
      avatar_url: "http://i.ytimg.com/vi/tntOCGkgt98/maxresdefault.jpg"
      )
      visit '/'
      sign_in_as(jim)
      fill_in 'title', with: "testyingggg"
      fill_in 'date', with: "2015/11/21"
      fill_in 'location', with: "the barn"
      fill_in 'description', with: "blarrrrggghhhhhh"
      click_button 'Submit'
      expect(page).to have_content("testyingggg")
      expect(page).to have_content("blarrrrggghhhhhh")
      expect(page).to have_content("You made a meetup")
    end

end
