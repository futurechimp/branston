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

      [:activate, :suspend, :destroy].each do |action|
        context "on POST to #{action.to_s}" do
          setup do
            post action
          end

          should "redirect to login" do
            assert_redirected_to new_session_path
          end
        end
      end

    end

    context "when logged in" do
      setup do
        login_as(User.make)
      end

      context "on GET to index" do
        context "as an admin user" do
          setup do
            @admin = User.make(:admin)
            login_as(@admin)
            get :index
          end
          should respond_with :success
          should render_template :index
          should assign_to :users
        end

        context "as a non-admin user" do
          setup do
            get :index
          end
          should redirect_to("the projects page") { projects_path }
          should set_the_flash.to("You are not allowed to do that.")
        end
      end

      context "on GET to new" do
        context "as an admin user" do
          setup do
            @admin = User.make(:admin)
            login_as(@admin)
            get :new
          end
          should respond_with :success
        end

        context "as a non-admin user" do
          setup do
            get :new
          end
          should redirect_to("the projects page") { projects_path }
          should set_the_flash.to("You are not allowed to do that.")
        end
      end

      context "on POST to create" do
        context "as an admin user" do
          setup do
            @admin = User.make(:admin)
            login_as(@admin)
          end
          context "with all parameters" do
            setup do
              @project = Project.make

              assert_difference 'User.count' do
                create_user(:role => "admin", :participations => [{:project => @project.to_param}])
              end
            end

            should redirect_to("the users page"){ users_path }

            should "set the user to be an admin" do
              assert assigns(:user).has_role?("admin")
            end

            should "create a project participation" do
              assert assigns(:user).participant?(@project)
            end
          end

          context "with the :state param set to 'active'" do
            setup do
              create_user(:state => "active")
            end

            should "create user with state 'active'" do
              assert_equal assigns(:user).state, "active"
            end
          end

          context "with no login supplied" do
            setup do
              assert_no_difference 'User.count' do
                create_user(:login => nil)
              end
            end

            should respond_with :success
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

            should respond_with :success
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

            should respond_with :success
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
            should respond_with :success
            should "have errors on the user's email" do
              assert assigns(:user).errors.on(:email)
            end
          end
        end

        context "as a non-admin user" do
          setup do
            post :create
          end

          should redirect_to("the projects page") { projects_path }
          should set_the_flash.to("You are not allowed to do that.")
        end
      end

      [:activate, :suspend, :destroy].each do |action|
        context "on POST to #{action.to_s}" do
          context "as a non-admin user" do
            setup do
              post action, :id => User.make.id
            end
            should redirect_to("the projects page") { projects_path }
            should set_the_flash.to("You are not allowed to do that.")
          end
        end
      end

      context "on POST to suspend" do
        context "as an admin user" do
          setup do
            login_as(User.make(:admin))
            @user = User.make(:state => "active")
            @original_state = @user.state
            post :suspend, :id => @user.id
          end
          should "suspend the user" do
            assert_equal User.find(@user.id).state, "suspended"
          end
        end
      end

      context "on POST to activate" do
        context "as an admin user" do
          context "when user has state 'suspended'" do
            setup do
              login_as(User.make(:admin))
              @user = User.make(:state => "suspended")
              @original_state = @user.state
              @user.activated_at = Time.now
              post :activate, :id => @user.id
            end
            should "activate the user" do
              assert_equal "active", assigns(:user).state
            end
          end
        end

        context "when user has state 'pending'" do
          context "as an admin user" do
            setup do
              login_as(User.make(:admin))
              @user = User.make(:state => "pending")
              @original_state = @user.state
              @user.activated_at = Time.now
              post :activate, :id => @user.id
            end
            should "activate the user" do
              assert_equal assigns(:user).state, "active"
            end
          end
        end
      end

      context "on POST to destroy" do
        context "as an admin user" do
          setup do
            login_as(User.make(:admin))
            @user = User.make(:state => "pending")
            @original_state = @user.state
            post :destroy, :id => @user.id
          end
          should "delete the user" do
            assert_equal assigns(:user).state, "deleted"
          end
        end
      end

      context "on GET to edit" do
        setup do
          @user = User.make
        end
        context "as an admin user" do
          setup do
            @admin = User.make(:admin)
            login_as(@admin)
            get :edit, :id => @user.id
          end
          should respond_with :success
          should render_template "edit"
          should assign_to :user
          should "retrieve the right user" do
            assert_equal @user, assigns(:user)
          end
        end

        context "for a user changing their own details" do
          setup do
            login_as(@user)
            get :edit, :id => @user.id
          end
          should respond_with :success
          should render_template "edit"
          should assign_to :user
          should "retrieve the right user" do
            assert_equal @user, assigns(:user)
          end
        end

        context "for a non-admin user" do
          setup do
            get :edit, :id => @user.id
          end
          should_not assign_to :user
          should redirect_to("the projects page") { projects_path }
          should set_the_flash.to "You are not allowed to do that."
        end
      end

      context "on PUT to update" do
        context "as an admin user" do
          setup do
            @user = User.make
            @project = Project.make
            @admin = User.make(:admin)
            login_as(@admin)
          end

          context "with good params" do
            setup do
              put :update, :id => @user.id, :user => {:email => "foo@superfoo.org", :role => "admin",  :participations => [{:project => @project.to_param}] }
            end
            should redirect_to("the users list") { users_path }
            should assign_to :user
            should "retrieve the right user" do
              assert_equal @user, assigns(:user)
            end
            should "update the email properly" do
              assert_equal "foo@superfoo.org", assigns(:user).email
            end
            should "allow the role change" do
              assert_equal true, assigns(:user).has_role?("admin")
            end

            should "create a project participation" do
              assert assigns(:user).participant?(@project)
            end
          end

          context "with bad params" do
            setup do
              put :update, :id => @user.id, :user => {:email => "foo", :role => "admin" }
            end
            should respond_with :success
            should render_template 'edit'
          end
        end

        context "as the user changing their own details" do
          setup do
            @user = User.make(:login => "foo")
            login_as(@user)
          end

          context "with good params" do
            setup do
              put :update, :id => @user.id, :user => {:email => "foo@superfoo.org", :is_admin => true }
            end
            should redirect_to("the users list") { users_path }
            should assign_to :user
            should "retrieve the right user" do
              assert_equal @user, assigns(:user)
            end
            should "update the email properly" do
              assert_equal "foo@superfoo.org", assigns(:user).email
            end
            should "not allow the is_admin state to change" do
              assert_equal false, assigns(:user).has_role?("admin")
            end
          end
          context "with bad params" do
            setup do
              put :update, :id => @user.id, :user => {:email => "foo", :is_admin => true }
            end
            should respond_with :success
            should render_template 'edit'
          end
        end

        context "as some random non-admin user" do
          setup do
            @user = User.make
            @another_user = User.make
            login_as(@another_user)
            put :update, :id => @user.id, :user => {:email => "foo", :role => "admin" }
            @user.reload
          end

          should redirect_to("the projects page") { projects_path }
          should set_the_flash.to "You are not allowed to do that."
          should "not allow the role change" do
            assert_not_equal("admin", @user.role)
          end
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

