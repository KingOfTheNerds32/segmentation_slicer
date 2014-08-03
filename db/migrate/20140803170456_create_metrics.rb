class CreateMetrics < ActiveRecord::Migration
  def change
    create_table :metrics do |t|
      t.integer :project_id
      t.string :bucket
      t.string :var
      t.string :label

      t.timestamps
    end
  end
end
