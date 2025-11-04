require "test_helper"

class EventsHelperTest < ActionView::TestCase
  test "event_icon for DiscussionEvent" do
    event = Event.new(event_type: 'DiscussionEvent', payload: {})
    assert_equal 'comment-discussion', event_icon(event)
  end

  test "event_name for DiscussionEvent" do
    assert_equal 'Discussion', event_name('DiscussionEvent')
  end
end
