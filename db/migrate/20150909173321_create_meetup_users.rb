class CreateMeetupUsers < ActiveRecord::Migration
  def change
    create_table :meetup_users do |table|
      table.integer :meetup_id
      table.integer :user_id
    end
  end
end
