require File.dirname(__FILE__) + '/../test_helper'
require 'users_controller'

# Re-raise errors caught by the controller.
class UsersController; def rescue_action(e) raise e end; end

class UsersControllerTest < ActionController::TestCase
  context "The UsersController" do
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

    context "when logged in" do
      setup do
        login_as(User.make)
      end

      context "on GET to index" do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template :index
        should_assign_to :users
      end

      context "on GET to new" do
        setup do
          get :new
        end
        should_respond_with :success
      end

      context "on POST to create" do
        context "with all parameters" do
          setup do
            assert_difference 'User.count' do
              create_user
            end
          end

          should_redirect_to("the home page"){ root_path }
        end

        context "with no login supplied" do
          setup do
            assert_no_difference 'User.count' do
              create_user(:login => nil)
            end
          end

          should_respond_with :success
          should "have errors on the user's login" do
            assert assigns(:user).errors.on(:login)
          end
        end

        context "with no password supplied" do
          setup do
            assert_no_difference 'User.count' do
              create_user(:password => nil)
            end
          end

          should_respond_with :success
          should "have errors on the user's password" do
            assert assigns(:user).errors.on(:password)
          end
        end

        context "with no password_confirmation supplied" do
          setup do
            assert_no_difference 'User.count' do
              create_user(:password_confirmation => nil)
            end
          end

          should_respond_with :success
          should "have errors on the user's password_confirmation" do
            assert assigns(:user).errors.on(:password_confirmation)
          end
        end

        context "with no email supplied" do
          setup do
            assert_no_difference 'User.count' do
              create_user(:email => nil)
            end
          end
          should_respond_with :success
          should "have errors on the user's email" do
            assert assigns(:user).errors.on(:email)
          end
        end
      end

      context "on POST to suspend" do
        context "when logged in" do
          setup do
            @user = User.make(:state => "active")
            login_as(@user)
            @original_state = @user.state
            post :suspend, :id => @user.id
          end
          should "suspend the user" do
            assert_equal User.find(@user.id).state, "suspended"
          end
        end
      end

      context "on POST to activate" do
        context "when user has state 'suspended'" do
          setup do
            @user = User.make(:state => "suspended")
            login_as(@user)
            @original_state = @user.state
            @user.activated_at = Time.now
            post :activate, :id => @user.id
          end
          should "activate the user" do
            assert_equal assigns(:user).state, "active"
          end
        end

        context "when user has state 'pending'" do
          setup do
            @user = User.make(:state => "pending")
            login_as(@user)
            @original_state = @user.state
            @user.activated_at = Time.now
            post :activate, :id => @user.id
          end
          should "activate the user" do
            assert_equal assigns(:user).state, "active"
          end
        end
      end

      context "on POST to destroy" do
        setup do
          @user = User.make(:state => "pending")
          @original_state = @user.state
          post :destroy, :id => @user.id
        end
        should "delete the user" do
          assert_equal assigns(:user).state, "deleted"
        end
      end
    end
  end

  protected

  def create_user(options = {})
    post :create, :user => { :login => 'quire', :email => 'quire@example.com',
      :password => 'quire69', :password_confirmation => 'quire69' }.merge(options)
  end
end

