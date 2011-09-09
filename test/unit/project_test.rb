  require 'test_helper'

class ProjectTest < ActiveSupport::TestCase

  context "The Project model" do

    should have_many :participations
    should have_many(:participants).through(:participations)
  	setup do
  		@project = Project.make
  	end

    should validate_presence_of :name
    should validate_uniqueness_of :name

    subject { @project }

    end

end

