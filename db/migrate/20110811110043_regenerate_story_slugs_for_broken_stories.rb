class RegenerateStorySlugsForBrokenStories < ActiveRecord::Migration
  def self.up
		stories = Story.all
		stories.each do |story|
			story.slug = story.title.parameterize
			story.save!
		end
  end

  def self.down
  end
end
