class CourseSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :avarage, :number_of_meetings, :meetings, :attendances, :modules, :teacher

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
    course_module_ids =  object.course_modules.where(module_id: 28).pluck(:mid)
    return Meeting.where('course_module_id in (?)', course_module_ids).count 
  end

  def meetings
    course_modules =  object.course_modules.where(module_id: 28).first
    return course_modules.meetings.order("start_time ASC") if !course_modules.blank?
  end


  def attendances
    result = []
    sco_ids = CourseSco.where(course_id: object.mid).pluck(:sco_id)
    attendances = Attendance.where('sco_id in (?)', sco_ids).group_by(&:principal_id)
    attendances.map do |principal_id, p_attendances|
      principal = Principal.find_by_principal_id(principal_id)
      if !principal.blank?
        sum = 0
        for p_at in p_attendances
          if !p_at.end_time.blank?
            sum += p_at.end_time.to_i - p_at.start_time.to_i
          end
        end
        sum > 0 ? minutes = (sum/60).to_f : minutes = 0
        object.total_avarage_time[:total] > 0 ? percent = (minutes / object.total_avarage_time[:total]) * 100 : percent = 0
        percent = 100 if percent > 100
        mprofile = MoodleProfile.where(utid: principal.uid).first
        !mprofile.blank? ? fullname = mprofile.fullname : fullname= ''
        result << {utid: principal.uid, fullname: fullname, sum: minutes.round, percent: percent.round}
      end
    end
    return result
  end

  def modules
    object.course_modules.where('module_id != ? and module_id != ?', 28,29).group('module_id').count
  end
end
