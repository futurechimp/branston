require 'test_helper'

class IterationsHelperTest < ActionView::TestCase

  include IterationsHelper

  context "The IterationsHelper" do

    context "burndown_data_js method" do
      setup do
        @iteration = Iteration.make_unsaved(:project => Project.make,
          :velocity => 40, :start_date => Date.today, :end_date => Date.today + 7)
        @weekdays = work_days @iteration
        @iteration.stories << Story.make(:transition_date => @weekdays[1], :points => 5, :status => 'quality_assurance')
        @iteration.stories << Story.make(:transition_date => @weekdays[2], :points => 4, :status => 'quality_assurance')
        @iteration.stories << Story.make(:transition_date => @weekdays[3], :points => 3, :status => 'completed')
        @iteration.stories << Story.make(:transition_date => @weekdays[4], :points => 1, :status => 'completed')
        @iteration.save!
        @burndown_data_js = burndown_data_js @iteration
      end
      should "return a Javascript object literal for use with the Google visualization API" do
        #puts @burndown_data_js
        burndown_json = JSON.parse(@burndown_data_js)
        assert_equal "A", burndown_json["cols"][0]["id"]
        assert_equal "B", burndown_json["cols"][1]["id"]
        assert_equal "C", burndown_json["cols"][2]["id"]
        assert_equal "#{@iteration.name} burndown chart", burndown_json["cols"][0]["label"]
        assert_equal "Quality Assurance", burndown_json["cols"][1]["label"]
        assert_equal "Completed", burndown_json["cols"][2]["label"]
        assert_equal "string", burndown_json["cols"][0]["type"]
        assert_equal "number", burndown_json["cols"][1]["type"]
        assert_equal "number", burndown_json["cols"][2]["type"]
        assert_equal @weekdays[0].strftime('%d-%m-%Y'), burndown_json["rows"][0]["c"][0]["v"]
        assert_equal 13, burndown_json["rows"][0]["c"][1]["v"]
        assert_equal "0 points. 13 remaining.", burndown_json["rows"][0]["c"][1]["f"]
        assert_equal @weekdays[2].strftime('%d-%m-%Y'), burndown_json["rows"][2]["c"][0]["v"]
        assert_equal 4, burndown_json["rows"][2]["c"][1]["v"]
        assert_equal "9 points. 4 remaining.", burndown_json["rows"][2]["c"][1]["f"]
        assert_equal @weekdays[3].strftime('%d-%m-%Y'), burndown_json["rows"][3]["c"][0]["v"]
        assert_equal 1, burndown_json["rows"][3]["c"][1]["v"]
        assert_equal "12 points. 1 remaining.", burndown_json["rows"][3]["c"][1]["f"]
      end
    end

    context "data_js_obj method" do

      setup do
        @iteration = Iteration.make_unsaved
        @js_cell_arr = [js_cell(Date.today, 38, 30, 35), js_cell(Date.today + 1, 38, 20, 25)]
        @data_js_obj = data_js_obj @iteration, @js_cell_arr
      end

      should "return JSON data compatible with Google Charts DataTable" do
        burndown_json = JSON.parse(@data_js_obj)
        assert_equal "A", burndown_json["cols"][0]["id"]
        assert_equal "B", burndown_json["cols"][1]["id"]
        assert_equal "C", burndown_json["cols"][2]["id"]
        assert_equal "#{@iteration.name} burndown chart", burndown_json["cols"][0]["label"]
        assert_equal "Quality Assurance", burndown_json["cols"][1]["label"]
        assert_equal "Completed", burndown_json["cols"][2]["label"]
      end
    end

    context "js_cell method" do

      setup do
        @iteration = Iteration.make_unsaved
        @js_cell_output = js_cell Date.today, 38, 20, 25
      end

      should "return a JSON snippet representing a Google Charts DataTable cell" do
        assert_equal %Q({"c":[{"v":"#{Date.today.strftime('%d-%m-%Y')}"}, {"v":20, "f":"18 points. 20 remaining."}, {"v":25, "f":"13 points. 25 remaining." }]}\n), @js_cell_output
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
