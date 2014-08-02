class Response < ActiveRecord::Base
  belongs_to :respondent
  belongs_to :metric
  belongs_to :value
end
