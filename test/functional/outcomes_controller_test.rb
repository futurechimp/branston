require 'test_helper'

class OutcomesControllerTest < ActionController::TestCase

  context "The OutcomesController" do
    context "when the user is not logged in" do
      [:new].each do |action|
        context "on GET to #{action.to_s}" do
          setup do
            get action
          end

          should "redirect to login" do
            assert_redirected_to new_session_path
          end
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
        @scenario = Scenario.make
        @outcome = Outcome.make
      end

      should "get new" do
        get :new, :scenario_id => @scenario.id
        assert_response :success
      end

      context "creating an outcome" do
        context "with valid params" do
          setup do
            assert_difference('Outcome.count') do
              post :create, :outcome => { :description => "Foo" }, :scenario_id => @scenario.id
            end
          end

          should "redirect after creation" do
            assert_response :success
          end

        end

        context "with invalid params" do
          setup do
            assert_no_difference('Outcome.count') do
              post :create, :outcome => { }, :scenario_id => @scenario.id
            end
          end

          should_eventually "do something with invalid params" do
						assert_response :success
            assert_template 'new'
          end
        end
      end

			context "destroy outcome" do
				setup do
	        assert_difference('Outcome.count', -1) do
	          delete :destroy, :id => @outcome.to_param
	        end
				end

        should "do something" do
					assert_response  :success
				end
      end
    end
  end
end

