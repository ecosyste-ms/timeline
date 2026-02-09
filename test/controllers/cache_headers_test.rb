require 'test_helper'

class CacheHeadersTest < ActionDispatch::IntegrationTest
  setup do
    @event = Event.create(
      id: 19885440325,
      actor: "Zahabul",
      event_type: "CreateEvent",
      repository: "Zahabul/humescores",
      owner: "Zahabul",
      payload: { "ref" => "main", "ref_type" => "branch" },
      created_at: Time.now
    )
  end

  test 'html pages include s-maxage for CDN caching' do
    get events_url
    assert_response :success
    assert_match(/s-maxage=21600/, response.headers['Cache-Control'])
  end

  test 'html pages include public and stale directives' do
    get events_url
    assert_match(/public/, response.headers['Cache-Control'])
    assert_match(/stale-while-revalidate=21600/, response.headers['Cache-Control'])
    assert_match(/stale-if-error=86400/, response.headers['Cache-Control'])
  end

  test 'api endpoints include s-maxage with shorter TTL' do
    get api_v1_events_url
    assert_response :success
    assert_match(/s-maxage=3600/, response.headers['Cache-Control'])
  end

  test 'root page includes cache headers' do
    get root_url
    assert_response :success
    assert_match(/s-maxage=21600/, response.headers['Cache-Control'])
  end
end
