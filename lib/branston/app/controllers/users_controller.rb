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

  before_filter :find_user, :only => [:suspend, :unsuspend, :destroy, :purge]
  before_filter :login_required

  def index
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
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end

  def suspend
    @user.suspend!
    redirect_to users_path
  end

  def unsuspend
    @user.unsuspend!
    redirect_to users_path
  end

  def destroy
    @user.delete!
    redirect_to users_path
  end

  def purge
    @user.destroy
    redirect_to users_path
  end

  # There's no page here to update or destroy a <%= file_name %>.  If you add those, be
  # smart -- make sure you check that the visitor is authorized to do so, that they
  # supply their old password along with a new one to update it, etc.

protected
  def find_user
    @user = User.find(params[:id])
  end

end

