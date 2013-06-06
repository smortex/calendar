class AddFbToEvents < ActiveRecord::Migration
  def change
    add_column :events, :fb, :integer

    execute "UPDATE events SET fb = 1;"
  end
end
