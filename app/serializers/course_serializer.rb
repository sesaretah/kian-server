class CourseSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :mid, :uuid, :title, :serial, :avarage, :number_of_meetings,
             :meetings, :attendances, :modules, :teacher,
             :bb_meetings, :number_of_bb_meetings, :bb_avarage,
             :student_view_histogram, :teacher_view_histogram,
             :students, :asset_sessions, :max, :course_percentile,
             :asset_start

  def id
    object.mid
  end

  def avarage
    object.total_avarage_time[:avarage]
  end

  def teacher
    teachers = CourseTeacher.where(course_id: object.mid).pluck(:fullname)
    teachers.first if !teachers.blank?
  end

  def student_view_histogram
    student_ids = CourseStudent.where(course_id: object.mid).pluck(:user_id).uniq
    MoodleCourse.connection.exec_query("select
            date_trunc('day', TO_TIMESTAMP(timecreated)) as Day,
            count(1)
        from mdl_logstore_standard_log
        where courseid = #{object.mid} and action = 'viewed' and target = 'course' and userid in (#{student_ids.join(",")})
        group by 1
        order by Day") rescue []
  end

  def teacher_view_histogram
    teacher_ids = CourseTeacher.where(course_id: object.mid).pluck(:user_id).uniq
    MoodleCourse.connection.exec_query("select
            date_trunc('day', TO_TIMESTAMP(timecreated)) as Day,
            count(1)
        from mdl_logstore_standard_log
        where courseid = #{object.mid} and action = 'viewed' and target = 'course' and userid in (#{teacher_ids.join(",")})
        group by 1
        order by Day") rescue []
  end

  def number_of_meetings
    #modules = [28, 36, 37, 38, 39]
    #sco_ids = []
    #course_module_ids =  object.course_modules.where('module_id in (?)', modules).pluck(:mid)
    #sco_ids = Meeting.where('course_module_id in (?)', course_module_ids).pluck(:sco_id).uniq if !course_module_ids.blank?
    return CourseMeeting.where(course_id: object.mid).count
  end

  def meetings
    #modules = [28, 36, 37, 38, 39]
    #meeting = []
    #course_modules =  object.course_modules.where('module_id in (?)', modules).first
    #course_module_ids =  object.course_modules.where('module_id in (?)', modules).pluck(:mid)
    #sco_ids = Meeting.where('course_module_id in (?)', course_module_ids).pluck(:sco_id).uniq if !course_module_ids.blank?
    #if !sco_ids.blank?
    #  for sco_id in sco_ids
    #    meeting << Meeting.where('sco_id = ?', sco_id).first
    #  end
    #end
    #return meeting
    return CourseMeeting.where(course_id: object.mid).order("start_time")
  end

  def bb_meetings
    BbMeeting.where(course_id: object.id)
  end

  def number_of_bb_meetings
    BbMeeting.where(course_id: object.id).count
  end

  def bb_avarage
    BbMeeting.total_avarage_time(object)[:avarage]
  end

  def attendances
    Attendance.connection.exec_query("select principals.uid, asset_id, duration from attendances 
    INNER JOIN principals ON principals.principal_id = attendances.principal_id
    where course_id = #{object.mid} and length(principals.uid) > 7
    group by principals.uid, asset_id, duration
    order by principals.uid desc")
  end

  def students
    Attendance.connection.exec_query("select principals.uid, principals.name from attendances 
      INNER JOIN principals ON principals.principal_id = attendances.principal_id
            where course_id = #{object.mid} and length(principals.uid) > 7
            group by principals.uid, principals.name")
  end

  def asset_sessions
    Attendance.connection.exec_query("select asset_id from attendances 
      where course_id = #{object.mid}
      group by asset_id
      order by asset_id
      ")
  end

  def asset_start
    Attendance.connection.exec_query("select distinct on (asset_id) asset_id, start_time from attendances 
      where course_id = #{object.mid}
      group by asset_id, start_time
      ")
  end

  def max
    Attendance.connection.exec_query("select asset_id, max(duration) from attendances 
    where course_id = #{object.mid}
    group by asset_id")
  end

  def modules
    object.course_modules.where("module_id != ? and module_id != ?", 28, 29).group("module_id").count
  end

  def course_percentile
    CoursePercentile.where(course_id: object.mid).first
  end
end
