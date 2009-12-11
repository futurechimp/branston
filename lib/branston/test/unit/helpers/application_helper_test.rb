require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase

  context "The element_id method" do

    context "when given an object" do

      context "with a new object" do
        setup do
          @obj = Scenario.new
          @id = element_id(@obj)
        end

        should "return a string" do
          assert_equal String, @id.class
        end

        should "return a string containing the class name" do
          # Story_
          assert_match /#{@obj.class.to_s}/, @id
        end

        context "with an existing object" do
          setup do
            @obj = Scenario.make
            @id = element_id(@obj)
          end

          should "return a string containing the class name and id" do
            assert_match /#{@obj.class.to_s}_#{@obj.id}/, @id
          end
        end
      end
    end

  end

end

