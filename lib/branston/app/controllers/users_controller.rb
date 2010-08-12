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

  before_filter :find_user, :only => [:suspend, :unsuspend, :destroy, :purge, :activate]
  before_filter :login_required
  before_filter :must_be_admin_or_self, :only => [:edit, :update]
  before_filter :must_be_admin, :only => [:create]

  def index
    @users = User.find(:all)
  end

  # render new.rhtml
  def new
    @user = User.new
  end

  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    @user.state = "pending"
    if @user && @user.valid? && @user.save!
      redirect_to users_url
      flash[:notice] = "User created."
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.is_admin = params[:user][:is_admin] if current_user.is_admin
    if @user.update_attributes(params[:user])
      redirect_to users_path
    else
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

  def must_be_admin_or_self
    user = User.find(params[:id])
    unless current_user.is_admin || current_user == user
      flash[:error] = "You are not allowed to edit users."
      redirect_to users_path
    end
  end

  def must_be_admin
    unless current_user.is_admin
      flash[:error] = "You are not allowed to create users."
      redirect_to users_path
    end
  end

end

