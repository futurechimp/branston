module IterationsHelper

  # TODO: Untested!
  #
  def burndown_chart(iteration, data)

    total_points = iteration.velocity
    running_total = 0

    unless data.nil? or data.empty?
      points_data = data.map { |d|
        running_total += d.points.to_i
        total_points - running_total
      }


      points_data = [total_points] + points_data unless points_data.nil?

      work_days = [nil]
      (iteration.start_date.to_date..iteration.end_date.to_date).to_a.each do |date|
        work_days.push date.strftime('%d/%m') unless is_weekend(date)
      end

      # Keep adding the last value to flatline the chart
      while work_days.length > points_data.length
        points_data.push points_data.last
      end

      # Make some gradations for the y axis labels
      y_scale = [0]
      [4, 2, 1.5, 1.25, 1].each do |n|
        unit = (total_points / n).floor
        y_scale.push unit if unit > 0
      end

      image_tag Gchart.line(:size => '800x360',
        :title => "Iteration #{iteration.name} burndown",
        :data => points_data, :axis_with_labels => 'x,y',
        :axis_labels => [work_days, y_scale])

    end

  end

  def is_weekend(date)
    date.wday == 0 or date.wday == 6
  end

end

