class Directory < ApplicationRecord
    belongs_to :user
    has_many :disk_files

    validates :name, presence: true
end
