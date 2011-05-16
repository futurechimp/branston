require 'test_helper'

class IterationsHelperTest < ActionView::TestCase

  include IterationsHelper

  context "The IterationsHelper" do

#    context "burndown_data_js method" do
#      setup do
#        @iteration = Iteration.make_unsaved(:project => Project.make,
#          :velocity => 40, :start_date => Date.today, :end_date => Date.today + 7)
#        weekdays = work_days @iteration
#        @iteration.stories << Story.make(:transition_date => weekdays[1], :points => 5, :status => 'quality_assurance')
#        @iteration.stories << Story.make(:transition_date => weekdays[2], :points => 4, :status => 'quality_assurance')
#        @iteration.stories << Story.make(:transition_date => weekdays[3], :points => 3, :status => 'completed')
#        @iteration.stories << Story.make(:transition_date => weekdays[4], :points => 1, :status => 'completed')
#        @iteration.save!
#        @burndown_data_js = burndown_data_js @iteration
#      end
#      should "return a Javascript object literal for use with the Google visualization API" do
         # TODO: Satan on a moped! this is hard to test.
#      end
#    end

    context "data_js_obj method" do

      setup do
        @iteration = Iteration.make_unsaved(:velocity => 40)
        @js_cell_arr = [js_cell(@iteration, Date.today, 30, 35), js_cell(@iteration, Date.today + 1, 20, 25)]
        @data_js_obj = data_js_obj @iteration, @js_cell_arr
      end

      should "return JSON data compatible with Google Charts DataTable" do
        assert_equal "{
  cols: [{id: 'A', label: '#{@iteration.name} burndown chart', type: 'string'},
         {id: 'B', label: 'Quality Assurance', type: 'number'},
         {id: 'C', label: 'Completed', type: 'number'}
        ],
  rows: [#{@js_cell_arr.join(",")}]
}\n", @data_js_obj
      end
    end

    context "js_cell method" do

      setup do
        @iteration = Iteration.make_unsaved(:velocity => 40)
        @js_cell_output = js_cell @iteration, Date.today, 20, 25
      end

      should "return a JSON snippet representing a Google Charts DataTable cell" do
        assert_equal "{c:[{v:'#{Date.today.strftime('%d-%m-%Y')}'}, {v:20, f:'20 points. 20 remaining.'}, {v: 25, f:'15 points. 25 remaining.' }]}\n", @js_cell_output
      end
    end

    context "work_days method" do
      setup do
        @iteration = Iteration.make_unsaved(:start_date => Date.today, :end_date => Date.today + 7)
        @weekdays = work_days @iteration
      end

      should "return all weekdays in the given iteration" do
        assert_equal 6, @weekdays.size
        @weekdays.each do |wd|
          assert wd.wday != 0
          assert wd.wday != 6
          assert wd.between?(@iteration.start_date.to_date, @iteration.end_date.to_date)
        end
      end
    end

  end

end
