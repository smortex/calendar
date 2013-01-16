class CreateRecurrences < ActiveRecord::Migration
  def change
    create_table :recurrences do |t|
      t.integer :days, :default => 0
      t.integer :weeks, :default => 0
      t.integer :months, :default => 0
      t.integer :years, :default => 0

      t.timestamps
    end
  end
end
