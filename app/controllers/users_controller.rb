#    This file is part of Branston.
#
#    Branston is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as published by
#    the Free Software Foundation.
#
#    Branston is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License
#    along with Branston.  If not, see <http://www.gnu.org/licenses/>.

class UsersController < ApplicationController

  layout 'main'

  before_filter :login_required
  before_filter :find_user, :only => [:suspend, :destroy, :activate]
  before_filter :must_be_admin, :only => [:index, :new, :create, :destroy, :suspend, :activate]
  before_filter :must_be_admin_or_self, :only => [:edit, :update]
  before_filter :capture_participations, :only => [:create, :update]

  def index
    @users = User.find(:all)
  end

  def new
    @user = User.new
    @user.password = @user.password_confirmation = nil
    @projects = Project.alphabetical
  end

  def create
    @user = User.new(params[:user])
    @user.role = params[:user][:role] if current_user.has_role?("admin")
    if @user && @user.valid? && @user.save!
      add_participations(@user)
      redirect_to users_url
      flash[:notice] = "User created."
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      @projects = Project.alphabetical
      render :action => 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
    @user.password = @user.password_confirmation = nil
    @projects = Project.alphabetical
  end

  def update
    @user = User.find(params[:id])
    @user.role = params[:user][:role] if current_user.has_role?("admin")
    if @user.update_attributes(params[:user])
      add_participations(@user)
      redirect_to users_path
    else
      @projects = Project.alphabetical
      render :action => 'edit'
    end
  end

  def suspend
    @user.suspend!
    redirect_to users_path
  end

  def activate
    @user.activate!
    redirect_to users_path
  end

  def destroy
    @user.delete!
    redirect_to users_path
  end

  protected

  def find_user
    @user = User.find(params[:id])
  end

  # A security filter which freezes out all non-admin users except the user
  # who is the user identified by params[:id]
  #
  def must_be_admin_or_self
    user = User.find(params[:id])
    unless current_user.has_role?("admin") || current_user == user
      flash[:error] = "You are not allowed to do that."
      redirect_to projects_path
    end
  end

  # A security filter which freezes out all non-admin users.
  #
  def must_be_admin
    unless current_user.has_role?("admin")
      flash[:error] = "You are not allowed to do that."
      redirect_to projects_path
    end
  end

  def capture_participations
    unless params[:user][:participations].nil?
      @participations = params[:user][:participations]
      params[:user].delete(:participations)
    end
  end

  def add_participations(user)
    if @participations
      # Blow em away
      Participation.find(:all, :conditions => ["user_id = ?", user.to_param]).each { |p| p.destroy }
      # Now re-add them.
      @participations.each do |participation|
        Participation.create(:user_id => user.to_param, :project_id => participation[:project])
      end
    end
  end
end