class AddSelfRefToDirectories < ActiveRecord::Migration[6.1]
  def change
    add_reference :directories, :parent, index: true
  end
end
