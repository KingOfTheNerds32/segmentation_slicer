class CreateMetrics < ActiveRecord::Migration
  def change
    create_table :metrics do |t|
      t.references :project, index: true
      t.references :metric, index: true
      t.string :metric_text

      t.timestamps
    end
  end
end
