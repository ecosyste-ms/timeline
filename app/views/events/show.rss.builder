xml.instruct! :xml, version: '1.0', encoding: 'UTF-8'
xml.rss version: '2.0' do
  xml.channel do
    xml.title @title
    xml.description "Recent GitHub events for #{@repository}"
    xml.link event_url(@repository, year: @year.year, event_type: params[:event_type])
    xml.language 'en'

    @events.each do |event|
      xml.item do
        xml.title "#{event.event_type} by #{event.actor}"
        xml.description "#{event.actor} - #{event.event_type}"
        xml.link event.html_url || event_url(@repository)
        xml.guid event_url(@repository, anchor: event.id), isPermaLink: false
        xml.pubDate event.created_at.rfc2822
      end
    end
  end
end
