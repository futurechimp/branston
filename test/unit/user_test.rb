require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase

  should have_many :stories
  should have_many :participations
  should have_many(:projects).through(:participations)

  context "the User class" do

    should "have a ROLES array in a constant" do
      assert_equal(["admin", "developer", "client"], User::ROLES)
    end

    should "create_user" do
      assert_difference 'User.count' do
        user = User.make
        assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
      end
    end

    should "require_login" do
      assert_no_difference 'User.count' do
        assert_raise ActiveRecord::RecordInvalid do
          u = User.make(:login => nil)
          assert u.errors.on(:login)
        end
      end
    end

    should "require_password" do
      assert_no_difference 'User.count' do
        assert_raise ActiveRecord::RecordInvalid do
          u = User.make(:password => nil)
          assert u.errors.on(:password)
        end
      end
    end

    should "require_password_confirmation" do
      assert_no_difference 'User.count' do
        assert_raise ActiveRecord::RecordInvalid do
          u = User.make(:password_confirmation => nil)
          assert u.errors.on(:password_confirmation)
        end
      end
    end

    should "require_email" do
      assert_no_difference 'User.count' do
        assert_raise ActiveRecord::RecordInvalid do
          u = User.make(:email => nil)

          assert u.errors.on(:email)
        end
      end
    end

    context "state machine transitions" do
      setup do
        @user = User.new
      end

      should "start life in the state 'pending'" do
        assert_equal("active", @user.state)
      end

      context "on activate" do
        context "from state :pending" do
          setup do
            @user.state = "pending"
            @user.activate
          end

          should "set the user's state to 'activated'" do
            assert_equal("active", @user.state)
          end
        end

        context "from state :suspended" do
          setup do
            @user.state = "suspended"
            @user.activate
          end

          should "set the user's state to 'activated'" do
            assert_equal("active", @user.state)
          end
        end

        context "from state :deleted" do
          setup do
            @user.state = "deleted"
          end

          should "raise an invalid transition exception" do
            assert_raise AASM::InvalidTransition do
             @user.activate
           end
          end

          should "leave the user's state as 'deleted'" do
            assert_equal("deleted", @user.state)
          end
        end
      end

      context "on :suspend" do
        context "from state :pending" do
          setup do
            @user.state = "pending"
            @user.suspend
          end

          should "set the user's state to 'suspended'" do
            assert_equal("suspended", @user.state)
          end
        end

        context "from state :active" do
          setup do
            @user.state = "active"
            @user.suspend
          end

          should "set the user's state to 'suspended'" do
            assert_equal("suspended", @user.state)
          end
        end

        context "from state :suspended" do
          setup do
            @user.state = "suspended"
          end

          should "raise an invalid transition exception" do
            assert_raise AASM::InvalidTransition do
             @user.suspend
           end
          end
        end

        context "from state :deleted" do
          setup do
            @user.state = "deleted"
          end

          should "raise an invalid transition exception" do
            assert_raise AASM::InvalidTransition do
             @user.suspend
           end
          end
        end
      end

      context "on :delete" do
        context "from state :pending" do
          setup do
            @user.state = "pending"
            @user.delete
          end

          should "set the user's state to 'deleted'" do
            assert_equal("deleted", @user.state)
          end
        end

        context "from state :active" do
          setup do
            @user.state = "active"
            @user.delete
          end

          should "set the user's state to 'deleted'" do
            assert_equal("deleted", @user.state)
          end
        end

        context "from state :suspended" do
          setup do
            @user.state = "suspended"
            @user.delete
          end

          should "set the user's state to 'deleted'" do
            assert_equal("deleted", @user.state)
          end
        end

        context "from state :deleted" do
          setup do
            @user.state = "deleted"
          end

          should "raise an invalid transition exception" do
            assert_raise AASM::InvalidTransition do
             @user.delete
           end
          end
        end
      end
    end
  end

  context "A user called quentin" do
    setup do
      @quentin = User.make(:quentin)
    end

    should "have the role 'client'" do
      assert @quentin.has_role?("client")
    end

    context "when setting the user's role" do
      context "to some non-existent role" do
        setup do
          @quentin.role = "something that doesn't exist"
        end

        should "not allow setting of role to something not in ROLES constant" do
          assert_raise(ActiveRecord::RecordInvalid) do
            @quentin.save!
          end
        end

        context "to a different, existing role" do
          setup do
            @quentin.role = "admin"
          end

          should "allow the role to be set" do
            assert_nothing_raised do
              @quentin.save!
            end
          end
        end
      end
    end

    should "not have the role 'admin'" do
      assert !@quentin.has_role?("admin")
    end

    should "print its login when to_s is called" do
      assert_equal "quentin", @quentin.to_s
    end

    should "reset_password" do
      @quentin.update_attributes(:password => 'new password', :password_confirmation => 'new password')
      assert_equal @quentin, User.authenticate('quentin', 'new password')
    end

    should "not_rehash_password" do
      @quentin.update_attributes(:login => 'quentin2')
      assert_equal @quentin, User.authenticate('quentin2', 'monkey')
    end

    should "authenticate_user" do
      assert_equal @quentin, User.authenticate('quentin', 'monkey')
    end

    should "set_remember_token" do
      @quentin.remember_me
      assert_not_nil @quentin.remember_token
      assert_not_nil @quentin.remember_token_expires_at
    end

    should "unset_remember_token" do
      @quentin.remember_me
      assert_not_nil @quentin.remember_token
      @quentin.forget_me
      assert_nil @quentin.remember_token
    end

    should "remember_me_for_one_week" do
      before = 1.week.from_now.utc
      @quentin.remember_me_for 1.week
      after = 1.week.from_now.utc
      assert_not_nil @quentin.remember_token
      assert_not_nil @quentin.remember_token_expires_at
      assert @quentin.remember_token_expires_at.between?(before, after)
    end

    should "remember_me_until_one_week" do
      time = 1.week.from_now.utc
      @quentin.remember_me_until time
      assert_not_nil @quentin.remember_token
      assert_not_nil @quentin.remember_token_expires_at
      assert_equal @quentin.remember_token_expires_at, time
    end

    should "remember_me_default_two_weeks" do
      before = 2.weeks.from_now.utc
      @quentin.remember_me
      after = 2.weeks.from_now.utc
      assert_not_nil @quentin.remember_token
      assert_not_nil @quentin.remember_token_expires_at
      assert @quentin.remember_token_expires_at.between?(before, after)
    end
  end
end

