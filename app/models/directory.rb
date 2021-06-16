class Directory < ApplicationRecord
    belongs_to :user
    belongs_to :parent, optional: true, :class_name => 'Directory'
    
    has_many_attached :files, dependent: :destroy
    has_many :children, :class_name => 'Directory',  :foreign_key => 'parent_id', dependent: :destroy

    validates :name, presence: true
    # validates :files, presence: true, blob: { max_size: 10.megabytes }

end