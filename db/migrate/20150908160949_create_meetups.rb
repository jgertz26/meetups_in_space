class CreateMeetups < ActiveRecord::Migration
  def change
    create_table :meetups do |table|
      table.string :title, null: false
      table.string :description, null: false
      table.string :location, null: false
      table.date :date, null: false
      table.timestamps
    end
  end
  create_index :meetups, :title, unique: true
end
