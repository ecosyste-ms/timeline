require "test_helper"

class EventsHelperTest < ActionView::TestCase
  test "event_icon for DiscussionEvent" do
    event = Event.new(event_type: 'DiscussionEvent', payload: {})
    assert_equal 'comment-discussion', event_icon(event)
  end

  test "event_name for DiscussionEvent" do
    assert_equal 'Discussion', event_name('DiscussionEvent')
  end

  test "event_icon for DiscussionCommentEvent" do
    event = Event.new(event_type: 'DiscussionCommentEvent', payload: {})
    assert_equal 'comment', event_icon(event)
  end

  test "event_name for DiscussionCommentEvent" do
    assert_equal 'Discussion Comment', event_name('DiscussionCommentEvent')
  end
end
