class AddAnyKeywordToProjectSettings < ActiveRecord::Migration
  def self.up
    add_column(:kb_project_settings, "any_keyword", :text)
  end

  def self.down
    remove_column(:kb_project_settings, "any_keyword")
  end
end