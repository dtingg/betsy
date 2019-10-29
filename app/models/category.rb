class Category < ApplicationRecord
  has_and_belongs_to_many :products, dependent: :nullify

  validates :name, presence: "true"
end
