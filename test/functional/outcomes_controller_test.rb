require 'test_helper'

class OutcomesControllerTest < ActionController::TestCase

  context "The OutcomesController" do
    setup do
      @outcome = Outcome.make
    end

    should "show a list of all the outcomes" do
      get :index
      assert_response :success
      assert_not_nil assigns(:outcomes)
    end

    should "show a form to add stories" do
      get :new
      assert_response :success
    end

    context "creating an outcome" do
      context "with valid params" do
        setup do
          assert_difference('Outcome.count') do
            post :create, :outcome => { :description => "Foo" }
          end
        end

        should "redirect after creation" do
          assert_redirected_to outcome_path(assigns(:outcome))
        end

      end

      context "with invalid params" do
        setup do
          assert_no_difference('Outcome.count') do
            post :create, :outcome => { }
          end
        end

        should "redisplay" do
          assert_response :success
        end
      end
    end

    context "updating an outcome" do
      context "with valid params" do
        setup do
          put :update, :id => @outcome.to_param, :outcome => {:description =>  "bar" }
        end

        should "redirect after update" do
          assert_redirected_to outcome_path(assigns(:outcome))
        end
      end

      context "with invalid params" do
        setup do
          put :update, :id => @outcome.to_param, :outcome => {:description => "" }
        end

        should "redisplay" do
          assert_response :success
        end
      end
    end

    should "update outcome" do
      put :update, :id => @outcome.to_param, :outcome => { }
      assert_redirected_to outcome_path(assigns(:outcome))
    end

    should "show outcome" do
      get :show, :id => @outcome.to_param
      assert_response :success
    end

    should "get edit" do
      get :edit, :id => @outcome.to_param
      assert_response :success
    end


    should "destroy outcome" do
      assert_difference('Outcome.count', -1) do
        delete :destroy, :id => @outcome.to_param
      end

      assert_redirected_to outcomes_path
    end
  end
end

