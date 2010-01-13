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

class PreconditionsController < ApplicationController

  layout 'main'
  before_filter :login_required
  before_filter :find_scenario, :except => [:destroy, :set_precondition_description]

  in_place_edit_for :precondition, :description

  # GET /preconditions
  # GET /preconditions.xml
  def index
    @preconditions = @scenario.preconditions

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @preconditions }
      format.js
    end
  end

  # GET /preconditions/1
  # GET /preconditions/1.xml
  def show
    @precondition = Precondition.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @precondition }
    end
  end

  # GET /preconditions/new
  # GET /preconditions/new.xml
  def new
    @precondition = Precondition.new
    @preconditions = @scenario.preconditions
    @preconditions.push @precondition
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @precondition }
      format.js
    end
  end

  # GET /preconditions/1/edit
  def edit
    @precondition = Precondition.find(params[:id])
  end

  # POST /preconditions
  # POST /preconditions.xml
  def create
    @precondition = Precondition.new(params[:precondition])
    @precondition.scenario = @scenario
    @preconditions = @scenario.preconditions
    respond_to do |format|
      if @precondition.save
        flash[:notice] = 'Precondition was successfully created.'
        format.html { redirect_to(@precondition) }
        format.xml  { render :xml => @precondition, :status => :created, :location => @precondition }
        format.js
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @precondition.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /preconditions/1
  # PUT /preconditions/1.xml
  def update
    @precondition = Precondition.find(params[:id])

    respond_to do |format|
      if @precondition.update_attributes(params[:precondition])
        flash[:notice] = 'Precondition was successfully updated.'
        format.html { redirect_to(@precondition) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @precondition.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /preconditions/1
  # DELETE /preconditions/1.xml
  def destroy
    @precondition = Precondition.find(params[:id])
    @precondition.destroy

    respond_to do |format|
      format.html { redirect_to(preconditions_url(:scenario_id => @precondition.scenario_id)) }
      format.xml  { head :ok }
      format.js
    end
  end

  private

  def find_scenario
    @scenario = Scenario.find(params[:scenario_id])
  end

end

