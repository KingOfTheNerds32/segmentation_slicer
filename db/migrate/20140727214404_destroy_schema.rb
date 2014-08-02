class DestroySchema < ActiveRecord::Migration
  def change
    drop_table :filters
    drop_table :metrics
    drop_table :responses
  end
end
