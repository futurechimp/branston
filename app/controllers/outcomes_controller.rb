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

class OutcomesController < ApplicationController

  before_filter :login_required
  before_filter :find_scenario, :except => [:destroy, :set_outcome_description]

  in_place_edit_for :outcome, :description

  # GET /outcomes/new
  # GET /outcomes/new.xml
  def new
    @outcome = Outcome.new
    @outcomes = @scenario.outcomes
    @outcomes.push @outcome
    respond_to do |format|
      format.xml  { render :xml => @outcome }
      format.js
    end
  end

  # POST /outcomes
  # POST /outcomes.xml
  def create
    @outcome = Outcome.new(params[:outcome])
    @outcome.scenario = @scenario
    @outcomes = @scenario.outcomes
    respond_to do |format|
      if @outcome.save
        format.xml  { render :xml => @outcome, :status => :created, :location => @outcome }
        format.js
      else
        format.xml  { render :xml => @outcome.errors, :status => :unprocessable_entity }
				format.js
      end
    end
  end

  # DELETE /outcomes/1
  # DELETE /outcomes/1.xml
  def destroy
    @outcome = Outcome.find(params[:id])
    @outcome.destroy

    respond_to do |format|
      format.xml  { head :ok }
      format.js
    end
  end

  private

  def find_scenario
    @scenario = Scenario.find(params[:scenario_id])
  end
end

