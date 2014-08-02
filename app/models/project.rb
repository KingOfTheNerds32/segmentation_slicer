class Project < ActiveRecord::Base
  belongs_to :project
  has_many :filters, dependent: :destroy
end
