module IterationsHelper

  # TODO: Untested!
  #
  def burndown_data_js(iteration)

    # The JSON output for our DataTable cells.
    cell_js = []
    # The weekdays in the iteration.
    work_days = (iteration.start_date.to_date..iteration.end_date.to_date).to_a.delete_if { |d| is_weekend(d) }
    # The burndown totals for QA and completed stories
    qa_burndown_total = iteration.velocity
    completed_burndown_total = iteration.velocity

    burndown_map = {}
    ['quality_assurance','completed'].each do |burndown_state|
      burndown_map[burndown_state] = {}
      iteration.burndown_data(burndown_state).each do |burndown_data|
        #unless burndown_data.transition_date.nil?
          burndown_map[burndown_state][burndown_data.transition_date.to_s] = burndown_data.points.to_i
        #end
      end
    end

    work_days.each do |wd|
      qa_burndown_total -= burndown_map['quality_assurance'][wd.to_s] || 0
      completed_burndown_total -= burndown_map['completed'][wd.to_s] || 0
      cell_js << "{c:[{v:'#{wd.strftime('%d/%m/%y')}'}, " +
      "{v:#{qa_burndown_total}, f:'#{qa_burndown_total} points'}, " +
      "{v:#{completed_burndown_total}, f:'#{completed_burndown_total} points' }]}"
    end

    "{
      cols: [{id: 'A', label: '#{iteration.name} burndown chart', type: 'string'},
             {id: 'B', label: 'Quality Assurance', type: 'number'},
             {id: 'C', label: 'Completed', type: 'number'}
            ],
      rows: [#{cell_js.join(",")}]
    }"

  end

  def is_weekend(date)
    date.wday == 0 or date.wday == 6
  end

end
