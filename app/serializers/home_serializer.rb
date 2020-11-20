class HomeSerializer < ActiveModel::Serializer
    include Rails.application.routes.url_helpers
    attributes :meeting_histogram, :bb_meeting_histogram,
    :hour_meeting_histogram
  
    def meeting_histogram
        result = []
        meetings = Meeting.connection.exec_query("select
            date_trunc('day', start_time) as Day,
            count(1)
        from meetings
        where start_time > '#{1.months.ago}'
        group by 1
        order by Day")
        for meeting in meetings
            if meeting['count'] > 20000
                meeting['count'] = meeting['count'].to_i - (meeting['count'].to_i * 3 / 4)
            end
            result << meeting
        end
        return result
    end

    def hour_meeting_histogram
        result = []
        meetings = Meeting.connection.exec_query("select
            date_trunc('hour', start_time) as Day,
            count(1)
        from meetings
        where start_time > '#{1.months.ago}'
        group by 1
        order by Day")
        for meeting in meetings
            if meeting['count'] > 10000
                meeting['count'] = meeting['count'].to_i - (meeting['count'].to_i * 3 / 4)
            end
            meeting['day'] = meeting['day'].to_datetime.in_time_zone("Tehran")
            result << meeting
        end
        return result
    end

    def bb_meeting_histogram
        BbMeeting.connection.exec_query("select
            date_trunc('day', start_time) as Day,
            count(1)
        from bb_meetings
        group by 1
        order by Day")
    end

  end
  