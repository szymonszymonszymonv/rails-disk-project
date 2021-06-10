class AddDirectoryRefToDiskFiles < ActiveRecord::Migration[6.1]
  def change
    add_reference :disk_files, :directory, index: true
  end
end
