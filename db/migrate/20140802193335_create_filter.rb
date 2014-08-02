class CreateFilter < ActiveRecord::Migration
  def change
    create_table :filters do |t|
      t.belongs_to :project
      t.integer :project_id
      t.string :group
      t.string :var
      t.integer :filter_val
      t.string :label
    end
  end
end
