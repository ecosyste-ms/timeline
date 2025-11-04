require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event = Event.create({"id"=>19885440325,
      "actor"=>"Zahabul",
      "event_type"=>"CreateEvent",
      "repository"=>"Zahabul/humescores",
      "owner"=>"Zahabul",
      "payload"=>{"ref"=>"main", "ref_type"=>"branch", "master_branch"=>"main", "description"=>nil, "pusher_type"=>"user"},
      "created_at"=>Time.now})

    @discussion_event = Event.create({"id"=>19885440326,
      "actor"=>"testuser",
      "event_type"=>"DiscussionEvent",
      "repository"=>"testuser/testrepo",
      "owner"=>"testuser",
      "payload"=>{
        "action"=>"created",
        "discussion"=>{
          "title"=>"Test Discussion",
          "body"=>"This is a test discussion",
          "html_url"=>"https://github.com/testuser/testrepo/discussions/1"
        }
      },
      "created_at"=>Time.now})
  end

  test 'should get index' do
    get events_url
    assert_response :success
    assert_template 'events/index'
  end

  test 'renders show' do
    get event_path("Zahabul/humescores")
    assert_response :success
    assert_template 'events/show'
  end

  test 'redirects to show' do
    get events_url(id: 'Zahabul/humescores')
    assert_response :redirect
  end

  test 'renders 404 for unknown repo' do
    assert_raises(ActiveRecord::RecordNotFound) do
      get event_path("foo/bar")
    end
  end

  test 'renders user events' do
    get user_path("Zahabul")
    assert_response :success
    assert_template 'events/user'
  end

  test 'renders user events with year parameter' do
    get user_path("Zahabul", year: 2024)
    assert_response :success
  end

  test 'renders user events with event_type parameter' do
    get user_path("Zahabul", event_type: 'CreateEvent')
    assert_response :success
  end

  test 'renders user events with before parameter' do
    get user_path("Zahabul", before: @event.id)
    assert_response :success
  end

  test 'index with event_type parameter' do
    get events_url(event_type: 'CreateEvent')
    assert_response :success
  end

  test 'index with before parameter' do
    get events_url(before: @event.id)
    assert_response :success
  end

  test 'index with after parameter' do
    get events_url(after: @event.id)
    assert_response :success
  end

  test 'show with year parameter' do
    get event_path("Zahabul/humescores", year: 2024)
    assert_response :success
  end

  test 'show with event_type parameter' do
    get event_path("Zahabul/humescores", event_type: 'CreateEvent')
    assert_response :success
  end

  test 'show with before parameter' do
    get event_path("Zahabul/humescores", before: @event.id)
    assert_response :success
  end

  test 'index loads events in controller' do
    get events_url
    assert assigns(:events).loaded?
  end

  test 'show loads events in controller' do
    get event_path("Zahabul/humescores")
    assert assigns(:events).loaded?
  end

  test 'user loads events in controller' do
    get user_path("Zahabul")
    assert assigns(:events).loaded?
  end

  test 'renders user events with DiscussionEvent' do
    get user_path("testuser")
    assert_response :success
    assert_template 'events/user'
  end

  test 'index with DiscussionEvent type parameter' do
    get events_url(event_type: 'DiscussionEvent')
    assert_response :success
  end
end