class FatlinksIndex < ActiveRecord::Migration
  def change
    add_index :fatlinks, :key
  end
end
