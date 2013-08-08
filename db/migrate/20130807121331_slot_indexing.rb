class SlotIndexing < ActiveRecord::Migration
  def change
    add_index :slots, :key
    add_index :slots, :api
  end
end
