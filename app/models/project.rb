class Project < ApplicationRecord
  belongs_to :organization, optional: true
  has_many :entries
  belongs_to :organization
end
