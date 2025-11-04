require "test_helper"

class EventTest < ActiveSupport::TestCase
  test "DiscussionEvent action_text for created" do
    event = Event.new(event_type: 'DiscussionEvent', payload: {'action' => 'created'})
    assert_equal 'created a discussion on', event.action_text
  end

  test "DiscussionEvent action_text for edited" do
    event = Event.new(event_type: 'DiscussionEvent', payload: {'action' => 'edited'})
    assert_equal 'edited a discussion on', event.action_text
  end

  test "DiscussionEvent action_text for answered" do
    event = Event.new(event_type: 'DiscussionEvent', payload: {'action' => 'answered'})
    assert_equal 'answered a discussion on', event.action_text
  end

  test "DiscussionEvent html_url" do
    event = Event.new(event_type: 'DiscussionEvent', payload: {
      'discussion' => {'html_url' => 'https://github.com/owner/repo/discussions/123'}
    })
    assert_equal 'https://github.com/owner/repo/discussions/123', event.html_url
  end
end
