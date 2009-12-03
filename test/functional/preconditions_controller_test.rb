require 'test_helper'

class PreconditionsControllerTest < ActionController::TestCase

  context "The PreconditionsController" do
    setup do
      @precondition = Precondition.make
    end

    should "get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:preconditions)
    end

    should "get new" do
      get :new
      assert_response :success
    end

    context "creating a precondition" do
      context "with valid params" do
        setup do
          assert_difference('Precondition.count') do
            post :create, :precondition => { :description => "Foo" }
          end
        end

        should "redirect to show" do
          assert_redirected_to precondition_path(assigns(:precondition))
        end

      end

      context "with invalid params" do
        setup do
          assert_no_difference('Precondition.count') do
            post :create, :precondition => { }
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
          put :update, :id => @precondition.to_param, :precondition => { :description => "Bar" }
        end
        should "redirect to show" do
          assert_redirected_to precondition_path(assigns(:precondition))
        end
      end

      context "with invalid params" do
        setup do
          put :update, :id => @precondition.to_param, :precondition => { :description => "" }
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
      get :show, :id => @precondition.to_param
      assert_response :success
    end

    should "get edit" do
      get :edit, :id => @precondition.to_param
      assert_response :success
    end

    should "update precondition" do
      put :update, :id => @precondition.to_param, :precondition => { }
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

