require 'test_helper'

class ScenariosControllerTest < ActionController::TestCase

  context "The ScenariosController" do
    setup do
      login_as(User.make)
      @story = Factory.make_story
      @iteration = @story.iteration
      @scenario = @story.scenarios.first
    end

    should "get index" do
      get :index, :story_id => @story.to_param, :iteration_id => @iteration.to_param
      assert_response :success
      assert_not_nil assigns(:scenarios)
    end

    should "get new" do
      get :new, :story_id => @story.to_param, :iteration_id => @iteration.to_param
      assert_response :success
    end

    context "creating a scenario" do
      context "with valid params" do
        setup do
          assert_difference('Scenario.count') do
            post :create, :scenario => { :title => "Foo" }, :story_id => @story.to_param,
            :iteration_id => @iteration.to_param
          end
        end

        should "redirect to show" do
          assert_redirected_to iteration_story_scenario_path(@iteration, assigns(:story), assigns(:scenario))
        end

      end

      context "with invalid params" do
        setup do
          assert_no_difference('Scenario.count') do
            post :create, :scenario => { }, :story_id => @story.to_param,
            :iteration_id => @iteration.to_param
          end
        end

        should "redisplay" do
          assert_response :success
        end

        should "use new template" do
          assert_template 'new'
        end

      end
    end

    context "updating a scenario" do
      context "with valid params" do
        setup do
          put :update, :id => @scenario.to_param, :scenario => { :title => "Bar" }, 
          :story_id => @story.to_param, :iteration_id => @iteration.to_param
        end
        should "redirect to show" do
          assert_redirected_to iteration_story_scenario_path(@iteration, assigns(:story), assigns(:scenario))
        end
      end

      context "with invalid params" do
        setup do
          put :update, :id => @scenario.to_param, :scenario => { :title => "" }, 
          :story_id => @story.to_param, :iteration_id => @iteration.to_param
        end

        should "redisplay" do
          assert_response :success
        end

        should "use edit template" do
          assert_template :edit
        end
      end
    end


    should "show scenario" do
      get :show, :id => @scenario.to_param, :story_id => @story.to_param, 
      :iteration_id => @iteration.to_param
      assert_response :success
    end

    should "get edit" do
      get :edit, :id => @scenario.to_param, :story_id => @story.to_param,
      :iteration_id => @iteration.to_param
      assert_response :success
    end

    should "destroy scenario" do
      assert_difference('Scenario.count', -1) do
        delete :destroy, :id => @scenario.to_param, :story_id => @story.to_param,
        :iteration_id => @iteration.to_param
      end
      assert_redirected_to iteration_story_scenarios_path(@iteration, @story.to_param)
    end
  end
end

