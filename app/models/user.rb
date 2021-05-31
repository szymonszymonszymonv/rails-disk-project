class User < ApplicationRecord
    
    has_many :directories, :dependent => :destroy
    accepts_nested_attributes_for :directories, :allow_destroy => true

    validates :email, presence: true
    validates :password, presence: true, length: { in: 6..20 }
    validates :password, confirmation: { case_sensitive: true }
end
