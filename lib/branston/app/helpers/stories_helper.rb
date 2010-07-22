module StoriesHelper
  
  def points_label(stories)
    points = 0
    stories.map { |s| points += s.points }
    "(#{points} points)"
  end
  
end
