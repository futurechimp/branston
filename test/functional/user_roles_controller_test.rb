require 'test_helper'

class UserRolesControllerTest < ActionController::TestCase
  
  context "the UserRolesController, with a given UserRole" do
    setup do
      @user_role = UserRole.make
    end
    
    should "get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:user_roles)
    end
    
    should "get new" do
      get :new
      assert_response :success
    end
    
    should "create user_role" do
      assert_difference('UserRole.count') do
        post :create, :user_role => { :name => 'customer' }
      end
      
      assert_redirected_to user_role_path(assigns(:user_role))
    end
    
    should "display validation errors on create" do
      assert_no_difference('UserRole.count') do
        post :create, :user_role => { :name => nil }
        assert_template :new
      end
    end
    
    should "show user_role" do
      get :show, :id => @user_role.to_param
      assert_response :success
    end
    
    should "get edit" do
      get :edit, :id => @user_role.to_param
      assert_response :success
    end
    
    should "update user_role" do
      assert_no_difference('UserRole.count') do
        put :update, :id => @user_role.to_param, :user_role => UserRole.plan
        assert_redirected_to user_role_path(assigns(:user_role))
      end
    end
    
    should "show validation errors on update" do
      assert_no_difference('UserRole.count') do
        put :update, :id => @user_role.to_param, :user_role => { :name => nil }
        assert_template :edit
      end
    end
    
    should "destroy user_role" do
      user = @user_role
      assert_difference('UserRole.count', -1) do
        delete :destroy, :id => user.to_param
      end
      
      assert_redirected_to user_roles_path
    end
  end
end
