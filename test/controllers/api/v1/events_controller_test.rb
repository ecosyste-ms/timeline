require 'test_helper'

class ApiV1EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event = Event.create({"id"=>19885440325,
      "actor"=>"Zahabul",
      "event_type"=>"CreateEvent",
      "repository"=>"Zahabul/humescores",
      "owner"=>"Zahabul",
      "payload"=>{"ref"=>"main", "ref_type"=>"branch", "master_branch"=>"main", "description"=>nil, "pusher_type"=>"user"},
      "created_at"=>Time.now})
  end

  test 'renders index' do
    get api_v1_events_path
    assert_response :success
    assert_template 'events/index', file: 'events/index.json.jbuilder'
    actual_response = JSON.parse(@response.body)
    assert_equal actual_response.length, 1
  end

  test 'renders show' do
    get api_v1_event_path("Zahabul/humescores")
    assert_response :success
    assert_template 'events/show', file: 'events/show.json.jbuilder'
    actual_response = JSON.parse(@response.body)
    assert_equal actual_response.length, 1
  end

  test 'renders 404 for unknown repo' do
    assert_raises(ActiveRecord::RecordNotFound) do
      get api_v1_event_path("foo/bar")
    end
  end
end