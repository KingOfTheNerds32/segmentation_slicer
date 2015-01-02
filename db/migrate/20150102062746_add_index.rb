class AddIndex < ActiveRecord::Migration
  def change
    add_index :responses, :var
    add_index :responses, :respondent_id
    add_index :responses, :response
  end
end
