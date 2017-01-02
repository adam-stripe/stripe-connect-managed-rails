class RenameLessonsToCourses < ActiveRecord::Migration[5.0]
  def change
    rename_table :lessons, :courses
  end
end
