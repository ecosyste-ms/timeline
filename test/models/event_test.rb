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

  test "DiscussionCommentEvent action_text for created" do
    event = Event.new(event_type: 'DiscussionCommentEvent', payload: {'action' => 'created'})
    assert_equal 'created a comment on a discussion on', event.action_text
  end

  test "DiscussionCommentEvent action_text for deleted" do
    event = Event.new(event_type: 'DiscussionCommentEvent', payload: {'action' => 'deleted'})
    assert_equal 'deleted a comment on a discussion on', event.action_text
  end

  test "DiscussionCommentEvent html_url" do
    event = Event.new(event_type: 'DiscussionCommentEvent', payload: {
      'comment' => {'html_url' => 'https://github.com/owner/repo/discussions/123#discussioncomment-456'}
    })
    assert_equal 'https://github.com/owner/repo/discussions/123#discussioncomment-456', event.html_url
  end

  test "format_event extracts fields from event json" do
    event_json = {
      'id' => '12345',
      'actor' => {'login' => 'testuser'},
      'type' => 'PushEvent',
      'repo' => {'name' => 'owner/repo'},
      'payload' => {'commits' => []},
      'created_at' => '2025-01-01T00:00:00Z'
    }
    result = Event.format_event(event_json)

    assert_equal '12345', result[:id]
    assert_equal 'testuser', result[:actor]
    assert_equal 'PushEvent', result[:event_type]
    assert_equal 'owner/repo', result[:repository]
    assert_equal 'owner', result[:owner]
  end

  test "format_event handles nil repo name" do
    event_json = {
      'id' => '12345',
      'actor' => {'login' => 'testuser'},
      'type' => 'PushEvent',
      'repo' => {'name' => nil},
      'payload' => {},
      'created_at' => '2025-01-01T00:00:00Z'
    }
    result = Event.format_event(event_json)

    assert_nil result[:repository]
    assert_nil result[:owner]
  end

  test "format_event handles missing repo key" do
    event_json = {
      'id' => '12345',
      'actor' => {'login' => 'testuser'},
      'type' => 'PushEvent',
      'payload' => {},
      'created_at' => '2025-01-01T00:00:00Z'
    }
    result = Event.format_event(event_json)

    assert_nil result[:repository]
    assert_nil result[:owner]
  end
end
