class AddIndexForProject < ActiveRecord::Migration
  def change
    add_index :responses, :project_id
  end
end
