class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.integer :project_id
      t.string :respondent_id
      t.string :var
      t.float :response
      t.float :weight

      t.timestamps
    end
  end
end
