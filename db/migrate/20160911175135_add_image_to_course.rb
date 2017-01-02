class AddImageToCourse < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :image, :string
  end
end
