require 'test_helper'

class PreconditionsControllerTest < ActionController::TestCase

  context "The PreconditionsController" do
    context "when the user is not logged in" do
      [:index, :new, :edit].each do |action|
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
        @scenario = Scenario.make
        @precondition = Precondition.make
      end

      should "get index" do
        get :index, :scenario_id => @scenario.id
        assert_response :success
        assert_not_nil assigns(:preconditions)
      end

      should "get new" do
        get :new, :scenario_id => @scenario.id
        assert_response :success
      end

      context "creating a precondition" do
        context "with valid params" do
          setup do
            assert_difference('Precondition.count') do
              post :create, :precondition => { :description => "Foo" }, :scenario_id => @scenario.id
            end
          end

          should "redirect to show" do
            assert_redirected_to precondition_path(assigns(:precondition))
          end

        end

        context "with invalid params" do
          setup do
            assert_no_difference('Precondition.count') do
              post :create, :precondition => { }, :scenario_id => @scenario.id
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


      context "updating a precondition" do
        context "with valid params" do
          setup do
            put :update, :id => @precondition.to_param, :precondition => { :description => "Bar" }, :scenario_id => @scenario.id
          end
          should "redirect to show" do
            assert_redirected_to precondition_path(assigns(:precondition))
          end
        end

        context "with invalid params" do
          setup do
            put :update, :id => @precondition.to_param, :precondition => { :description => "" }, :scenario_id => @scenario.id
          end

          should "redisplay" do
            assert_response :success
          end

          should "use edit template" do
            assert_template :edit
          end
        end
      end


      should "show precondition" do
        get :show, :id => @precondition.to_param, :scenario_id => @scenario.id
        assert_response :success
      end

      should "get edit" do
        get :edit, :id => @precondition.to_param, :scenario_id => @scenario.id
        assert_response :success
      end

      should "update precondition" do
        put :update, :id => @precondition.to_param, :precondition => { }, :scenario_id => @scenario.id
        assert_redirected_to precondition_path(assigns(:precondition))
      end

      should "destroy precondition" do
        assert_difference('Precondition.count', -1) do
          delete :destroy, :id => @precondition.to_param
        end

        assert_redirected_to preconditions_path
      end
    end
  end
end

