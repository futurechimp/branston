  require 'test_helper'

class ProjectTest < ActiveSupport::TestCase

  context "The Project model" do

  	setup do
  		@project = Project.make
  	end

    subject { @project }

    end

end

