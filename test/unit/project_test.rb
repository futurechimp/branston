  require 'test_helper'

class ProjectTest < ActiveSupport::TestCase

  context "The Project model" do

  	setup do
  		@project = Project.make
  	end

    should_validate_presence_of :name
    should_validate_uniqueness_of :name

    subject { @project }

    end

end

