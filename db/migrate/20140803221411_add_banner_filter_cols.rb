class AddBannerFilterCols < ActiveRecord::Migration
  def change
    add_column :filters, :filter, :boolean
    add_column :filters, :banner, :boolean
  end
end
