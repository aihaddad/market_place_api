class User < ActiveRecord::Base
  # Relations
  has_many :products, dependent: :destroy

  # Callbacks
  before_create :generate_authentication_token!

  # Validations
  validates :auth_token, uniqueness: true


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  def generate_authentication_token!
    begin
      self.auth_token = Devise.friendly_token
    end while self.class.exists?(auth_token: auth_token)
  end
end
