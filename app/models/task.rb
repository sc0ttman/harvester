class Task < ApplicationRecord
  has_many :entries
  belongs_to :organization
end
