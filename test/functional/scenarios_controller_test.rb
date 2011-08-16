require 'test_helper'

class ScenariosControllerTest < ActionController::TestCase

  context "The ScenariosController" do
    context "when the user is not logged in" do
      [:new, :edit].each do |action|
        context "on GET to #{action.to_s}" do
          setup do
            get action
          end

          should "redirect to login" do
            assert_redirected_to new_session_path
          end
        end
      end

      context "on PUT to :update" do
        setup do
          put :update
        end
        should "redirect to login" do
          assert_redirected_to new_session_path
        end
      end

      context "on POST to :create" do
        setup do
          post :create
        end
        should "redirect to login" do
          assert_redirected_to new_session_path
        end
      end
    end

    context "when the user is logged in" do
      setup do
        login_as(User.make)
        @story = Factory.make_story
        @iteration = @story.iteration
        @scenario = @story.scenarios.first
      end

      should "get new" do
        get :new, :story_id => @story.slug, :iteration_id => @iteration.to_param
        assert_response :success
      end

      context "creating a scenario" do
        context "with valid params" do
          setup do
            assert_difference('Scenario.count') do
              post :create, :scenario => { :title => "Foo"} , :story_id => @story.slug,
              :iteration_id => @iteration.to_param
            end
          end

          should "redisplay" do
            assert_response :success
          end
        end

        context "with invalid params" do
          setup do
            assert_no_difference('Scenario.count') do
              post :create, :scenario => { }, :story_id => @story.to_param,
              :iteration_id => @iteration.to_param
            end
          end

          should_eventually "do something with invalid params" do
						assert_response :success
            assert_template 'new'
          end

        end
      end

      context "destroy scenario" do
				setup do
	        assert_difference('Scenario.count', -1) do
	          delete :destroy, :id => @scenario.to_param, :story_id => @story.to_param,
	          :iteration_id => @iteration.to_param
	        end
				end
				
				should "do something" do
					assert_response  :success
				end
      end
    end
  end
end

