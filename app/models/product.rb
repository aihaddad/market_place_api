class Product < ActiveRecord::Base
  # Relations
  belongs_to :user

  # Validations
  validates :title, :user_id, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }, 
                    presence: true
end
