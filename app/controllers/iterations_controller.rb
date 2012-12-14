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


class IterationsController < ApplicationController

  layout 'main'

  # Filters
  #
  before_filter :login_required
  before_filter :find_all_releases, :only => [:new, :edit]
	before_filter :find_project
  before_filter :format_date_params, :only => [:create, :update]

  # GET /iterations/1
  # GET /iterations/1.xml
  def show
    @iteration = Iteration.find(params[:id])

    respond_to do |format|
      format.html #{ render :layout => 'burndown' }
      format.xml  { render :xml => @iteration }
    end
  end

  # GET /iterations/new
  # GET /iterations/new.xml
  def new
    @iteration = Iteration.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @iteration }
    end
  end

  # GET /iterations/1/edit
  def edit
    @iteration = Iteration.find(params[:id])
  end

  # POST /iterations
  # POST /iterations.xml
  def create
    @iteration = Iteration.new(params[:iteration])
		@iteration.project = @project

    respond_to do |format|
      if @iteration.save
        flash[:notice] = 'Iteration was successfully created.'
        format.html { redirect_to project_path(@project) }
        format.xml  { render :xml => @iteration, :status => :created, :location => @iteration }
      else
        find_project
        find_all_releases
        format.html { render :action => "new" }
        format.xml  { render :xml => @iteration.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /iterations/1
  # PUT /iterations/1.xml
  def update
    @iteration = Iteration.find(params[:id])

    respond_to do |format|
      if @iteration.update_attributes(params[:iteration])
        flash[:notice] = 'Iteration was successfully updated.'
        format.html { redirect_to project_path(@project) }
        format.xml  { head :ok }
      else
				find_project
        find_all_releases
        format.html { render :action => "edit" }
        format.xml  { render :xml => @iteration.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /iterations/1
  # DELETE /iterations/1.xml
  def destroy
    @iteration = Iteration.find(params[:id])
    @iteration.destroy

    respond_to do |format|
      format.html { redirect_to project_path(@project) }
      format.xml  { head :ok }
    end
  end

  private

  def find_all_releases
    @releases = Release.all
  end

	def find_project
		@project = Project.find(params[:project_id]) unless params[:project_id].nil?
	end

  def format_date_params
    params[:iteration][:start_date] = DateTime.strptime(params[:iteration][:start_date], "%d/%m/%Y").to_s if params[:iteration][:start_date]
    params[:iteration][:end_date] = DateTime.strptime(params[:iteration][:end_date], "%d/%m/%Y").to_s if params[:iteration][:end_date]
  end

end

