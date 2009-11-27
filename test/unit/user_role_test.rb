require 'test_helper'

class UserRoleTest < ActiveSupport::TestCase
  
  test "validates name" do
    assert !UserRole.new.valid?
    assert UserRole.new(:name => 'customer').valid?
  end
end
