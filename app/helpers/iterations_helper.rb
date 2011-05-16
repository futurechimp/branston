module IterationsHelper

  def burndown_data_js(iteration)

    # The JSON properties for our DataTable cells.
    js_cell_arr = []
    # The burndown totals for QA and completed stories
    qa_burndown_total = iteration.velocity
    completed_burndown_total = iteration.velocity
    # Map story points keyed by date for both QA and complete stories.
    burndown_map = {}
    ['quality_assurance','completed'].each do |burndown_state|
      burndown_map[burndown_state] = {}
      iteration.burndown_data(burndown_state).each do |burndown_data|
        burndown_map[burndown_state][burndown_data.transition_date.to_s] = burndown_data.points.to_i
      end
    end

    # Run through the work days in this iteration (assumes Saturday and Sundays off)
    # and decrement the iteration totals for QA/Complete stories.
    # Format the expected JSON as we go.
    work_days(iteration).each do |wd|
      # Decrement the QA burndown total
      qa_burndown_total -= burndown_map['quality_assurance'][wd.to_s] || 0
      # Completed stories have passed QA so the QA count needs to be decremented.
      qa_burndown_total -= burndown_map['completed'][wd.to_s] || 0
      # Decrement the Completed burndown total
      completed_burndown_total -= burndown_map['completed'][wd.to_s] || 0
      # Push a formatted JS string into the cell array
      js_cell_arr << js_cell(iteration, wd, qa_burndown_total, completed_burndown_total)
    end

    data_js_obj iteration, js_cell_arr

  end

  protected

  def data_js_obj(iteration, js_cell_arr)
    template = ERB.new <<-EOF
{
  cols: [{id: 'A', label: '#{iteration.name} burndown chart', type: 'string'},
         {id: 'B', label: 'Quality Assurance', type: 'number'},
         {id: 'C', label: 'Completed', type: 'number'}
        ],
  rows: [<%= js_cell_arr.join(",") %>]
}
    EOF
    template.result(binding)
  end

  def js_cell(iteration, date, qa_total, completed_total)
    template = ERB.new <<-EOF
{c:[{v:'<%= date.strftime('%d-%m-%Y') %>'}, {v:<%= qa_total %>, f:'<%= iteration.velocity - qa_total %> points. <%= qa_total %> remaining.'}, {v: <%= completed_total %>, f:'<%= iteration.velocity - completed_total %> points. <%= completed_total %> remaining.' }]}
    EOF
    template.result(binding)
  end

  def work_days(iteration)
    (iteration.start_date.to_date..iteration.end_date.to_date).to_a.delete_if { |d| is_weekend(d) }
  end

  def is_weekend(date)
    date.wday == 0 or date.wday == 6
  end

end
