class ScenariosController < ApplicationController

  before_filter :find_story, :except => :set_scenario_title

  in_place_edit_for :scenario, :title


  # GET /stories/:story_id/scenarios/new
  # GET /stories/:story_id/scenarios/new.xml
  def new
    @scenario = Scenario.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @story }
      format.js   { render :partial => "scenario" }
    end
  end

  # POST /stories/:story_id/scenarios
  # POST /stories/:story_id/scenarios.xml
  def create
    @scenario = Scenario.new(params[:scenario])
    @scenario.story = @story
    respond_to do |format|
      if @scenario.save
        flash[:notice] = 'Scenario was successfully created.'
        format.html { redirect_to(@scenario) }
        format.xml  { render :xml => @scenario, :status => :created, :location => @scenario }
        format.js { @scenarios = Scenario.find :all, :conditions => ["story_id = ?", @story.id] }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @scenario.errors, :status => :unprocessable_entity }
      end
    end
  end

  def index
    @scenarios = Scenario.find :all, :conditions => ["story_id = ?", @story.id]
    respond_to do |format|
      format.html
      format.js { render :partial => "scenarios" }
    end
  end

  private

  def find_story
    @story = Story.find(params[:story_id]) if @story.nil?
  end

end

