class User < ApplicationRecord
    
    has_many :directories
    validates :email, presence: true
    validates :password, presence: true, length: { in: 6..20 }
    validates :password, confirmation: { case_sensitive: true }
end
