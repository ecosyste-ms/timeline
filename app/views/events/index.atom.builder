xml.instruct! :xml, version: '1.0', encoding: 'UTF-8'
xml.feed xmlns: 'http://www.w3.org/2005/Atom' do
  xml.title @title
  xml.subtitle 'Recent GitHub events indexed by ecosyste.ms'
  xml.id events_url(event_type: params[:event_type])
  xml.link href: events_url(event_type: params[:event_type])
  xml.link href: events_url(event_type: params[:event_type], format: :atom), rel: 'self', type: 'application/atom+xml'
  xml.updated((@events.first&.created_at || Time.current).iso8601)

  @events.each do |event|
    xml.entry do
      xml.title "#{event.event_type} in #{event.repository}"
      xml.id event_url(event.repository, anchor: event.id)
      xml.link href: (event.html_url || event_url(event.repository))
      xml.updated event.created_at.iso8601
      xml.summary "#{event.actor} - #{event.event_type}"
    end
  end
end
