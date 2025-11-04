module EventsHelper
  def event_icon(event)
    case event.event_type
    when 'WatchEvent'
      'star-fill'
    when "CreateEvent"
      case event.payload['ref_type']
      when 'tag'
        'tag'
      when 'repository'
        'repo'
      else
      'git-branch'
      end
    when "CommitCommentEvent"
      'git-commit'
    when "ReleaseEvent"
      'tag'
    when "IssuesEvent"
      case event.payload['action']
      when 'closed'
        'issue-closed'
      when 'reopened'
        'issue-reopened'
      else
        'issue-opened'
      end
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
      case event.payload['action']
      when 'closed'
        'git-pull-request-closed'
      else
        if event.payload['pull_request']['draft']
          'git-pull-request-draft'
        else
          'git-pull-request'
        end
      end
    when "ForkEvent"
      'repo-forked'
    when 'MemberEvent'
      'person-add'
    when 'DiscussionEvent'
      'comment-discussion'
    else
      nil
    end
  end


  def event_name(event_type)
    case event_type
    when 'WatchEvent'
      'Starred'
    when "CreateEvent"
      'Branched'
    when "CommitCommentEvent"
      'Commit Comment'
    when "ReleaseEvent"
      'Release'
    when "IssuesEvent"
      'Issue'
    when "DeleteEvent"
      'Delete Branch'
    when "IssueCommentEvent"
      'Issue Comment'
    when "PublicEvent"
      'Open Sourced'
    when "PushEvent"
      'Pushed'
    when "PullRequestReviewCommentEvent"
      'Review Comment'
    when "PullRequestReviewEvent"
      'Review'
    when "PullRequestEvent"
      'Pull Request'
    when "ForkEvent"
      'Forked'
    when 'MemberEvent'
      'Member'
    when 'GollumEvent'
      'Wiki update'
    when 'DiscussionEvent'
      'Discussion'
    else
      "*#{event_type}*"
    end
  end
end
