class CreateLessons < ActiveRecord::Migration[5.0]
  def change
    create_table :lessons do |t|
      t.integer :user_id
      t.string :title
      t.string :description
      t.integer :price
      t.boolean :subscription

      t.timestamps
    end
  end
end
