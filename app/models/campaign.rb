class Campaign < ApplicationRecord
  belongs_to :users

  validates :title,
  presence: true, length: { minimum: 5, maximum: 100 }

  validates :goal, 
  presence: true, numericality: { greater_than: 20, less_than: 20000 }

  validates :description,
  presence: true, length: { minimum: 10, maximum: 5000 }
end
