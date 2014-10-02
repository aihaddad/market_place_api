class Product < ActiveRecord::Base
  # Relations
  belongs_to :user

  # Validations
  validates :title, :user_id, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }, 
                    presence: true
  
  scope :filter_by_title, lambda { |keyword| where("lower(title) LIKE ?", "%#{keyword.downcase}%") }
  scope :above_or_equal_to_price, lambda { |price| where("price >= ?", price) }
  scope :below_or_equal_to_price, lambda { |price| where("price <= ?", price) }
  scope :recent, lambda { order(:updated_at) }
end
