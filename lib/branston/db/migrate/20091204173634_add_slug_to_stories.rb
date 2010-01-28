class AddSlugToStories < ActiveRecord::Migration
  def self.up
    add_column :stories, :slug, :string, :null => false, :default => ''
    Story.all.each do |story|
      story.slug = story.title.parameterize
      story.save!
    end
  end

  def self.down
    remove_column :stories, :slug
  end
end
