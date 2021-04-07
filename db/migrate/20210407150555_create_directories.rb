class CreateDirectories < ActiveRecord::Migration[6.1]
  def change
    create_table :directories do |t|
      t.string :name
      t.integer :size
      # t.datetime :modified_at

      t.timestamps
    end
  end
end
