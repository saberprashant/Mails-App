class User < ApplicationRecord
  serialize :mailIds, Array
  
  has_secure_password

  validates :email, presence: true, uniqueness: true

end
