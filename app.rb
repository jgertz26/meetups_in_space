require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'omniauth-github'

require_relative 'config/application'
set :environment, :development

Dir['app/**/*.rb'].each { |file| require_relative file }

helpers do
  def current_user
    user_id = session[:user_id]
    @current_user ||= User.find(user_id) if user_id.present?
  end

  def signed_in?
    current_user.present?
  end

  def in_group?(meetup)
    users = meetup.users
    users.include?(current_user)
  end
end

def set_current_user(user)
  session[:user_id] = user.id
end

def authenticate!
  unless signed_in?
    flash[:notice] = 'You need to sign in if you want to do that!'
    redirect '/'
  end
end

get '/' do
  @meetups = Meetup.all.order(:title)
  erb :index, locals: {meetups: @meetups}
end

post '/' do
  authenticate!
  new_meetup = Meetup.new(title: params["title"], description: params["description"], location: params["location"], date: params["date"])
  if new_meetup.save
    flash[:notice] = 'You made a meetup!'
    new_joiner = MeetupUser.create(meetup: new_meetup, user: current_user)
    redirect "/meetups/#{new_meetup.id}"
  else
    flash[:notice] = new_meetup.errors.full_messages.last
    redirect "/"
  end
end

get '/meetups/:id' do
  @meetup = Meetup.find(params[:id])
  erb :show, locals: {meetup: @meetup}
end

post '/meetups/:id/join' do
  authenticate!
  user = current_user
  meetup = Meetup.find(params[:id])
  new_joiner = MeetupUser.new(meetup: meetup, user: user)
  if new_joiner.save
    flash[:notice] = "You're invited!"
  end
  redirect "/meetups/#{params[:id]}"
end

post '/meetups/:id/leave' do
  meetup = Meetup.find(params[:id])
  relation = MeetupUser.find_by(meetup: meetup, user: current_user)
  relation.destroy
  flash[:notice] = "You're uninvited, DORK!"
  redirect "/meetups/#{params[:id]}"
end

get '/auth/github/callback' do
  auth = env['omniauth.auth']

  user = User.find_or_create_from_omniauth(auth)
  set_current_user(user)
  flash[:notice] = "You're now signed in as #{user.username}!"

  redirect '/'
end

get '/sign_out' do
  session[:user_id] = nil
  flash[:notice] = "You have been signed out."

  redirect '/'
end
