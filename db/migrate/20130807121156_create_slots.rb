class CreateSlots < ActiveRecord::Migration
  def change
    create_table :slots do |t|
      t.string :key
      t.string :api
      t.text :data

      t.timestamps
    end
  end
end
