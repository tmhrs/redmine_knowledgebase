class CreateProjectSettings < ActiveRecord::Migration
  def change
    create_table :kb_project_settings do |t|
      t.column :project_id,                     :integer, :null => false
      t.column :flg_involved_articles,          :boolean, :default => true
      t.column :show_involved_articles_count,   :integer, :default => 5
      t.column :use_columns_for_default_search, :text
      t.timestamps
    end
  end

  def self.down
    drop_table :kb_project_settings
  end
end

