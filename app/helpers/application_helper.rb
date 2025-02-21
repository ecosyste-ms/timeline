module ApplicationHelper
  def meta_title
    [@meta_title, 'Ecosyste.ms: Timeline'].compact.join(' | ')
  end

  def meta_description
    @meta_description || app_description
  end

  def app_name
    "Timeline"
  end

  def app_description
    "Browse the timeline of events for every public repo on GitHub. Data updated hourly from GH Archive."
  end
end