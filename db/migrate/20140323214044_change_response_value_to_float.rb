class ChangeResponseValueToFloat < ActiveRecord::Migration
  def change
    change_column :responses, :value_id, :float
  end
end
