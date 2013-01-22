class CalendarsActsAsNestedSet < ActiveRecord::Migration
  def up
    add_column :calendars, :parent_id, :integer
    add_column :calendars, :rgt, :integer
    add_column :calendars, :lft, :integer

    Calendar.rebuild!
  end

  def down
    remove_column :calendars, :parent_id
    remove_column :calendars, :rgt, :integer
    remove_column :calendars, :lft, :integer
  end
end
