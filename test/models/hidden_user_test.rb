require "test_helper"

class HiddenUserTest < ActiveSupport::TestCase
  test "normalizes login before saving" do
    hidden_user = HiddenUser.create!(login: "SomeUser")

    assert_equal "someuser", hidden_user.login
    assert HiddenUser.hidden?("SOMEUSER")
  end
end
