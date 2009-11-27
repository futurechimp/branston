require File.dirname(__FILE__) + '/../test_helper'
require 'sessions_controller'

# Re-raise errors caught by the controller.
class SessionsController; def rescue_action(e) raise e end; end
  
class SessionsControllerTest < ActionController::TestCase
  
  context "the SessionsController" do
    
    setup do
      @quentin = User.make(:quentin)
    end
    
    should "login_and_redirect" do
      post :create, :login => 'quentin', :password => 'monkey'
      assert session[:user_id]
      assert_response :redirect
    end
    
    should "fail_login_and_not_redirect" do
      post :create, :login => 'quentin', :password => 'bad password'
      assert_nil session[:user_id]
      assert_response :success
    end
    
    should "logout" do
      login_as @quentin
      get :destroy
      assert_nil session[:user_id]
      assert_response :redirect
    end
    
    should "remember_me" do
      @request.cookies["auth_token"] = nil
      post :create, :login => 'quentin', :password => 'monkey', :remember_me => "1"
      assert_not_nil @response.cookies["auth_token"]
    end
    
    should "not_remember_me" do
      @request.cookies["auth_token"] = nil
      post :create, :login => 'quentin', :password => 'monkey', :remember_me => "0"
      puts @response.cookies["auth_token"]
      assert @response.cookies["auth_token"].blank?
    end
    
    should "delete_token_on_logout" do
      login_as @quentin
      get :destroy
      assert @response.cookies["auth_token"].blank?
    end

    should "login_with_cookie" do
      @quentin.remember_me
      @request.cookies["auth_token"] = cookie_for(@quentin)
      get :new
      assert @controller.send(:logged_in?)
    end
    
    should "fail_expired_cookie_login" do
      @quentin.remember_me
      @quentin.update_attribute :remember_token_expires_at, 5.minutes.ago
      @request.cookies["auth_token"] = cookie_for(@quentin)
      get :new
      assert !@controller.send(:logged_in?)
    end
    
    should "fail_cookie_login" do
      @quentin.remember_me
      @request.cookies["auth_token"] = auth_token('invalid_auth_token')
      get :new
      assert !@controller.send(:logged_in?)
    end
    
  end
  
  protected
  def auth_token(token)
    CGI::Cookie.new('name' => 'auth_token', 'value' => token)
  end
  
  def cookie_for(user)
    auth_token user.remember_token
  end
end

