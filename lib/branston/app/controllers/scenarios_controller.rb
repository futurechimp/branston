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

class ScenariosController < ApplicationController

  layout 'main'
  before_filter :login_required
  before_filter :load_iteration_and_story, :except => [:set_scenario_title]

  in_place_edit_for :scenario, :title

  def index
    @scenarios = @story.scenarios
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /scenarios/1
  # GET /scenarios/1.xml
  def show
    @scenario = Scenario.find(params[:id])

    respond_to do |format|
      format.html # scenario.html.erb
      format.xml  { render :xml => @scenario }
    end
  end

  # GET /stories/:story_id/scenarios/new
  # GET /stories/:story_id/scenarios/new.xml
  def new
    @scenario = Scenario.new
    @scenarios = @story.scenarios
    @scenarios.push @scenario
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @story }
      format.js
    end
  end


  # GET /scenarios/1/edit
  def edit
    @scenario = Scenario.find(params[:id])
  end

  # POST /stories/:story_id/scenarios
  # POST /stories/:story_id/scenarios.xml
  def create
    @scenario = Scenario.new(params[:scenario])
    @scenario.story = @story
    respond_to do |format|
      if @scenario.save
        @scenarios = @story.scenarios
        flash[:notice] = 'Scenario was successfully created.'
        format.html { redirect_to iteration_story_scenario_path(@iteration, @story, @scenario) }
        format.xml  { render :xml => @scenario, :status => :created, :location => @scenario }
        format.js
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @scenario.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /scenarios/1
  # PUT /scenarios/1.xml
  def update
    @scenario = Scenario.find(params[:id])
    respond_to do |format|
      if @scenario.update_attributes(params[:scenario])
        flash[:notice] = 'Scenario was successfully updated.'
        format.html { redirect_to iteration_story_scenario_path(@iteration, @story, @scenario) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @scenario.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /stories/1
  # DELETE /stories/1.xml
  def destroy
    @scenario = Scenario.find(params[:id])
    @story = @scenario.story
    @scenario.destroy

    respond_to do |format|
      format.html { redirect_to(iteration_story_scenarios_path(@iteration, @story)) }
      format.xml  { head :ok }
      format.js
    end
  end


  private

  def load_iteration_and_story
    @story = Story.find_by_slug(params[:story_id]) if @story.nil?
    @iteration = Iteration.find(params[:iteration_id])
  end

end

