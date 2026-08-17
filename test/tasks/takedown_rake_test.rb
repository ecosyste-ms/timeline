require "test_helper"
require "rake"

class TakedownRakeTest < ActiveSupport::TestCase
  setup do
    Rails.application.load_tasks unless Rake::Task.task_defined?("takedown:hide_user")
  end

  teardown do
    ENV.delete("LOGIN")
  end

  test "hide_user creates a tombstone and preserves stored events" do
    actor_event = Event.create!(id: 10, actor: "TargetUser", owner: "other", payload: {}, created_at: Time.current)
    owner_event = Event.create!(id: 11, actor: "other", owner: "TARGETUSER", payload: {}, created_at: Time.current)
    other_event = Event.create!(id: 12, actor: "other", owner: "other", payload: {}, created_at: Time.current)
    ENV["LOGIN"] = "TARGETUSER"

    output, = capture_io { Rake::Task["takedown:hide_user"].execute }

    assert HiddenUser.hidden?("targetuser")
    assert Event.exists?(actor_event.id)
    assert Event.exists?(owner_event.id)
    assert_equal [other_event], Event.visible.order(:id).to_a
    assert_includes output, "[timeline] hidden user targetuser; stored events were not modified"
  end

  test "hide_user is idempotent" do
    HiddenUser.create!(login: "targetuser")
    ENV["LOGIN"] = "TargetUser"

    assert_no_difference -> { HiddenUser.count } do
      capture_io { Rake::Task["takedown:hide_user"].execute }
    end
  end

  test "hide_user aborts without LOGIN" do
    assert_raises(SystemExit) do
      capture_io { Rake::Task["takedown:hide_user"].execute }
    end
  end

  test "report describes a hidden user" do
    HiddenUser.create!(login: "hidden-user")
    ENV["LOGIN"] = "HIDDEN-USER"

    output, = capture_io { Rake::Task["takedown:report"].execute }

    assert_includes output, "[timeline] HIDDEN-USER: user=hidden; stored events are preserved"
  end
end
