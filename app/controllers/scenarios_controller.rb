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

  # GET /stories/:story_id/scenarios/new
  # GET /stories/:story_id/scenarios/new.xml
  def new
    @scenario = Scenario.new
    @scenarios = @story.scenarios
    @scenarios.push @scenario
    respond_to do |format|
      format.xml  { render :xml => @story }
      format.js
    end
  end

  # POST /stories/:story_id/scenarios
  # POST /stories/:story_id/scenarios.xml
  def create
    @scenario = Scenario.new(params[:scenario])
    @scenario.story = @story
    respond_to do |format|
      if @scenario.save
        @scenarios = @story.scenarios
        format.xml  { render :xml => @scenario, :status => :created }
        format.js
      else
        format.xml  { render :xml => @scenario.errors, :status => :unprocessable_entity }
				format.js
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

