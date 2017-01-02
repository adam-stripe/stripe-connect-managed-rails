class AddContentLinkToCourses < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :content_link, :string
  end
end
