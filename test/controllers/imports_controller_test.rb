require 'test_helper'

class ImportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @import = Import.create(filename: 'foobar', event_count: 100)
    @event = Event.create({"id"=>19885440325,
      "actor"=>"Zahabul",
      "event_type"=>"CreateEvent",
      "repository"=>"Zahabul/humescores",
      "owner"=>"Zahabul",
      "payload"=>{"ref"=>"main", "ref_type"=>"branch", "master_branch"=>"main", "description"=>nil, "pusher_type"=>"user"},
      "created_at"=>Time.now})
  end

  test 'renders index' do
    get root_path
    assert_response :success
    assert_template 'imports/index'
  end
end