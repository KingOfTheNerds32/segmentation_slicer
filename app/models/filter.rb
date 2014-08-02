class Filter < ActiveRecord::Base
  belongs_to :project
  belongs_to :metric
  belongs_to :value
end
