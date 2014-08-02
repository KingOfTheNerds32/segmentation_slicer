class CreateFilters < ActiveRecord::Migration
  def change
    create_table :filters do |t|
      t.references :project, index: true
      t.references :metric, index: true
      t.references :value, index: true
      t.string :value_text

      t.timestamps
    end
  end
end
