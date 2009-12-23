module IterationsHelper

  # TODO: Untested!
  #
  def burndown_chart(iteration, data)

    total_points = 0
    points_data = []

    unless data.nil? or data.empty?
      total_points = data[0].total_points.to_i
      points_data = data.collect{|d| d.points.to_i}
    end

    work_days = []
    (iteration.start_date.to_date..iteration.end_date.to_date).to_a.each do |date|
      work_days.push date.strftime('%d/%m') unless date.wday == 0 or date.wday == 6
    end

    # Keep adding the last value to flatline the chart
    while work_days.length > data.length
      data.push data[data.length - 1]
    end

    # Make some gradations for the y axis labels
    y_scale = [0]
    [4, 2, 1.5, 1.25, 1].each do |n|
      unit = (total_points / n).floor
      y_scale.push unit if unit > 0
    end

    image_tag Gchart.line(:size => '500x300',
            :title => "#{iteration.name} burndown",
            :data => points_data, :axis_with_labels => 'x,y',
            :axis_labels => [work_days, y_scale])

  end

end

