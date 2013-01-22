class AddLastEventIdToRecurrences < ActiveRecord::Migration
  def change
    add_column :recurrences, :last_event_id, :integer

    execute <<-SQL
      UPDATE recurrences SET last_event_id = (SELECT id FROM events WHERE events.recurrence_id = recurrences.id ORDER BY stop DESC LIMIT 1);
    SQL
  end
end
