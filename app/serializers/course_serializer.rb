class CourseSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :mid, :title, :serial, :avarage, :number_of_meetings,
             :meetings, :attendances, :modules, :teacher,
             :bb_meetings, :number_of_bb_meetings, :bb_avarage

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
    result = []
    sco_ids = CourseSco.where(course_id: object.mid).pluck(:sco_id)
    attendances = Attendance.where("sco_id in (?)", sco_ids).group_by(&:principal_id)
    attendances.map do |principal_id, p_attendances|
      principal = Principal.find_by_principal_id(principal_id)
      if !principal.blank?
        sum = 0
        for p_at in p_attendances
          if !p_at.end_time.blank?
            sum += p_at.end_time.to_i - p_at.start_time.to_i
          end
        end
        sum > 0 ? minutes = (sum / 60).to_f : minutes = 0
        object.total_avarage_time[:total] > 0 ? percent = (minutes / object.total_avarage_time[:total]) * 100 : percent = 0
        percent = 100 if percent > 100
        mprofile = MoodleProfile.where(utid: principal.uid).first
        !mprofile.blank? ? fullname = mprofile.fullname : fullname = ""
        result << { utid: principal.uid, fullname: fullname, sum: minutes.round, percent: percent.round }
      end
    end
    return result
  end

  def modules
    object.course_modules.where("module_id != ? and module_id != ?", 28, 29).group("module_id").count
  end
end
