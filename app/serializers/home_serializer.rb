class HomeSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :meeting_histogram, :bb_meeting_histogram,
             :hour_meeting_histogram, :course_views_histogram,
             :usage_pi, :sessions_pi, :boxplot

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
    # meetings = Meeting.connection.exec_query("select
    #         date_trunc('hour', start_time) as Day,
    #         count(1)
    #     from course_meetings
    #     where start_time > '#{2.months.ago}'
    #     group by 1
    #     order by Day")

    meetings = Meeting.connection.exec_query("
        SELECT 
          CASE 
            WHEN date_part('hour',start_time AT TIME ZONE 'UTC') BETWEEN 0 AND 7 THEN '6'
            WHEN date_part('hour',start_time AT TIME ZONE 'UTC') BETWEEN 7 AND 9 THEN '8'
            WHEN date_part('hour',start_time AT TIME ZONE 'UTC') BETWEEN 9 AND 11 THEN '10' 
            WHEN date_part('hour',start_time AT TIME ZONE 'UTC') BETWEEN 11 AND 13 THEN '12' 
            WHEN date_part('hour',start_time AT TIME ZONE 'UTC') BETWEEN 13 AND 15 THEN '14' 
            WHEN date_part('hour',start_time AT TIME ZONE 'UTC') BETWEEN 15 AND 17 THEN '16'
            WHEN date_part('hour',start_time AT TIME ZONE 'UTC') BETWEEN 17 AND 19 THEN '18'
            WHEN date_part('hour',start_time AT TIME ZONE 'UTC') BETWEEN 19 AND 21 THEN '20'
            WHEN date_part('hour',start_time AT TIME ZONE 'UTC') BETWEEN 21 AND 23 THEN '22'
          END,
        COUNT(*)
        FROM course_meetings
        GROUP BY  
          CASE 
          WHEN date_part('hour',start_time AT TIME ZONE 'UTC') BETWEEN 0 AND 7 THEN '6'
          WHEN date_part('hour',start_time AT TIME ZONE 'UTC') BETWEEN 7 AND 9 THEN '8'
          WHEN date_part('hour',start_time AT TIME ZONE 'UTC') BETWEEN 9 AND 11 THEN '10' 
          WHEN date_part('hour',start_time AT TIME ZONE 'UTC') BETWEEN 11 AND 13 THEN '12' 
          WHEN date_part('hour',start_time AT TIME ZONE 'UTC') BETWEEN 13 AND 15 THEN '14' 
          WHEN date_part('hour',start_time AT TIME ZONE 'UTC') BETWEEN 15 AND 17 THEN '16'
          WHEN date_part('hour',start_time AT TIME ZONE 'UTC') BETWEEN 17 AND 19 THEN '18'
          WHEN date_part('hour',start_time AT TIME ZONE 'UTC') BETWEEN 19 AND 21 THEN '20'
          WHEN date_part('hour',start_time AT TIME ZONE 'UTC') BETWEEN 21 AND 23 THEN '22'
        END
        ")
    #for meeting in meetings
    #if meeting['count'] > 10000
    #    meeting['count'] = meeting['count'].to_i - (meeting['count'].to_i * 3 / 4)
    #end
    #  meeting["day"] = meeting["day"].to_datetime.in_time_zone("Tehran")
    #  result << meeting
    #end
    for meeting in meetings.sort_by { |hsh| hsh["case"].to_i }
      result << { meeting["case"] => meeting["count"] }
    end
    return meetings.sort_by { |hsh| hsh["case"].to_i }
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

  def boxplot
    result = Meeting.connection.exec_query("SELECT faculty_id, course_id, SUM(duration), ntile(4) over (order by SUM(duration)) as quartile 
    FROM course_meetings
    INNER JOIN courses on course_meetings.course_id = courses.mid
    GROUP BY course_id, faculty_id
    order by faculty_id")
    h = result.rows.group_by { |item| item[0].itself.to_s[0..1] }
    return h.transform_keys { |key| Section.where(mid: key).first.title }
  end
end
