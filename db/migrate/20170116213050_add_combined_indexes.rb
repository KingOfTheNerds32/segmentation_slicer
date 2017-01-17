class AddCombinedIndexes < ActiveRecord::Migration
  def change
      add_index "responses", ["project_id", "var", "respondent_id", "response"] ,unique: true ,name: 'index_responses_p_var_resp_r'
      add_index "responses", ["project_id", "var", "respondent_id"] ,unique: true ,name: 'index_responses_p_var_resp' 
      add_index "responses", ["project_id", "respondent_id"] , name: 'index_responses_p_resp'
  end
end
