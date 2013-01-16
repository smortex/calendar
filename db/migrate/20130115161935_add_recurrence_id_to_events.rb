class AddRecurrenceIdToEvents < ActiveRecord::Migration
  def change
    add_column :events, :recurrence_id, :integer
  end
end
