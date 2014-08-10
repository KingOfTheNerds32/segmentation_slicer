class Project < ActiveRecord::Base
  belongs_to :project
  has_many :filters, dependent: :destroy
  has_many :metrics, dependent: :destroy
  has_many :responses, dependent: :destroy
end
