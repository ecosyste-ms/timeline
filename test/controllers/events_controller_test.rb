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
end