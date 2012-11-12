class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :calendar_id
      t.string :title
      t.text :body
      t.datetime :start
      t.datetime :stop

      t.timestamps
    end
  end
end
