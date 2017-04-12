class Project < ApplicationRecord
  belongs_to :organization, optional: true
  has_many :entries
end
