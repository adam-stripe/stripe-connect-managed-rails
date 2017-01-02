class ChangeDescriptionInCourses < ActiveRecord::Migration[5.0]
  def change
    change_column :courses, :description, :text
  end
end
