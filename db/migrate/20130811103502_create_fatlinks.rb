class CreateFatlinks < ActiveRecord::Migration
  def change
    create_table :fatlinks do |t|
      t.string :key
      t.text :data

      t.timestamps
    end
  end
end
