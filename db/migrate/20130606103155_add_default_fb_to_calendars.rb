class AddDefaultFbToCalendars < ActiveRecord::Migration
  def change
    add_column :calendars, :default_fb, :integer, default: 1
  end
end
