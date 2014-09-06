class Metric < ActiveRecord::Base
  belongs_to :project

  def self.to_csv(options = {})
    columns_to_include = ["bucket", "var", "label"]
    CSV.generate(options) do |csv|
      csv << columns_to_include
        all.each do |metric|
          csv << metric.attributes.values_at(*columns_to_include)
        end
      end
  end
end