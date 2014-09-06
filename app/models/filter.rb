class Filter < ActiveRecord::Base
  belongs_to :project

  def self.to_csv(options = {})
    columns_to_include = ["group", "var", "filter_val", "label", "filter", "banner"]
    CSV.generate(options) do |csv|
      csv << columns_to_include
        all.each do |filter|
          csv << filter.attributes.values_at(*columns_to_include)
        end
      end
  end
end
