module EventsHelper
  def event_icon(event)
    case event.event_type
    when 'WatchEvent'
      'star'
    when "CreateEvent"
      'git-branch'
    when "CommitCommentEvent"
      'comment'
    when "ReleaseEvent"
      'tag'
    when "IssuesEvent"
      'issue-opened'
    when "DeleteEvent"
      'trash'
    when "IssueCommentEvent"
      'comment'
    when "PublicEvent"
      'squirrel'
    when "PushEvent"
      'repo-push'
    when "PullRequestReviewCommentEvent"
      'comment-discussion'
    when "PullRequestReviewEvent"
      'code-review'
    when "PullRequestEvent"
      'git-pull-request'
    when "ForkEvent"
      'repo-forked'
    when 'MemberEvent'
      'person'
    end
  end


  def event_name(event_type)
    case event_type
    when 'WatchEvent'
      'Starred'
    when "CreateEvent"
      'Branched'
    when "CommitCommentEvent"
      'Commit Comments'
    when "ReleaseEvent"
      'Release'
    when "IssuesEvent"
      'Issues'
    when "DeleteEvent"
      'Delete Branch'
    when "IssueCommentEvent"
      'Issue Comment'
    when "PublicEvent"
      'Open Sourced'
    when "PushEvent"
      'Pushed'
    when "PullRequestReviewCommentEvent"
      'Review Comments'
    when "PullRequestReviewEvent"
      'Review'
    when "PullRequestEvent"
      'Pull Requests'
    when "ForkEvent"
      'Forked'
    when 'MemberEvent'
      'Member'
    when 'GollumEvent'
      'Wiki update'
    else
      "*#{event_type}*"
    end
  end
end
