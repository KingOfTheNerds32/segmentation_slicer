class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.references :respondent, index: true
      t.references :metric, index: true
      t.references :value, index: true

      t.timestamps
    end
  end
end
