class Directory < ApplicationRecord
    belongs_to :users
    has_many :disk_files
end
