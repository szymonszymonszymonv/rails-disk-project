class Directory < ApplicationRecord
    belongs_to :user
    belongs_to :parent, :class_name => 'Directory'
    has_many :disk_files
    has_many :children, :class_name => 'Directory', :foreign_key => 'parent_id'
    
    validates :name, presence: true
end
