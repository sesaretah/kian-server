class HomeSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :meeting_histogram, :bb_meeting_histogram,
             :hour_meeting_histogram, :course_views_histogram,
             :usage_pi, :sessions_pi

  def meeting_histogram
    result = []
    meetings = Meeting.connection.exec_query("select
            date_trunc('day', start_time) as Day,
            count(1)
        from course_meetings
        where start_time > '#{Time.at(1612965838)}'
        group by 1
        order by Day")
    for meeting in meetings
      #if meeting['count'] > 20000
      #    meeting['count'] = meeting['count'].to_i - (meeting['count'].to_i * 3 / 4)
      #end
      result << meeting
    end
    return result
  end

  def hour_meeting_histogram
    result = []
    meetings = Meeting.connection.exec_query("select
            date_trunc('hour', start_time) as Day,
            count(1)
        from course_meetings
        where start_time > '#{1.months.ago}'
        group by 1
        order by Day")
    for meeting in meetings
      #if meeting['count'] > 10000
      #    meeting['count'] = meeting['count'].to_i - (meeting['count'].to_i * 3 / 4)
      #end
      meeting["day"] = meeting["day"].to_datetime.in_time_zone("Tehran")
      result << meeting
    end
    return result
  end

  def bb_meeting_histogram
    BbMeeting.connection.exec_query("select
            date_trunc('day', start_time) as Day,
            count(1)
        from bb_meetings
        where start_time > '#{Time.at(1612965838)}'
        group by 1
        order by Day")
  end

  def usage_pi
    meeting_duration = Meeting.connection.exec_query("SELECT SUM (duration) AS total
    FROM course_meetings;")
    bb_meeting_duration = Meeting.connection.exec_query("SELECT SUM (duration) AS total
    FROM bb_meetings where start_time > '#{Time.at(1612965838)}' ;")
    return [meeting_duration[0]["total"], bb_meeting_duration[0]["total"]]
  end

  def sessions_pi
    meeting_duration = Meeting.connection.exec_query("SELECT count(*)
    FROM course_meetings;")
    bb_meeting_duration = Meeting.connection.exec_query("SELECT count(*)
    FROM bb_meetings where start_time > '#{Time.at(1612965838)}' ;")
    return [meeting_duration[0]["count"], bb_meeting_duration[0]["count"]]
  end

  def course_views_histogram
    MoodleCourse.connection.exec_query("
      select
            date_trunc('day', TO_TIMESTAMP(timecreated)) as Day,
            count(1)
        from mdl_logstore_standard_log
        where  action = 'viewed' and target = 'course' 
        group by 1
        order by Day
      ")
  end
end
