class RegenerateStorySlugsForBrokenStories < ActiveRecord::Migration
  def self.up
		stories = Story.all
		stories.each do |story|
			story.title = story.title + "*"
			story.save!
		end
  end

  def self.down
  end
end
