class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.references :project, index: true
      t.string :project_name

      t.timestamps
    end
  end
end
