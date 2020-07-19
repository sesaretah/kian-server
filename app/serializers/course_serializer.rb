class CourseSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :avarage, :number_of_meetings, :meetings, :attendances

  def id
    object.mid
  end 

  def avarage
    total = 0
    num = 0 
    avg = 0
    course_modules =  object.course_modules.where(module_id: 28).first
    if !course_modules.blank?
      for meeting in object.course_modules.where(module_id: 28).first.meetings
        total += meeting.duration.abs
        num += 1
     end
    end
    if total > 0 && num > 0
      avg = total/num
    end
    return avg
  end

  def number_of_meetings
    course_modules =  object.course_modules.where(module_id: 28).first
    return course_modules.meetings.count if !course_modules.blank?
  end

  def meetings
    course_modules =  object.course_modules.where(module_id: 28).first
    return course_modules.meetings.order("start_time ASC") if !course_modules.blank?
  end

  def attendances
    result = []
    course_modules =  object.course_modules.where(module_id: 28).first
    if !course_modules.blank?
      sco_ids = course_modules.meetings.pluck(:sco_id)
      attendances = Attendance.where('sco_id in (?)', sco_ids).group_by(&:principal_id)
      attendances.map do |principal_id, p_attendances|
        principal = Principal.find_by_principal_id(principal_id)
        if !principal.blank?
          sum = 0
          for p_at in p_attendances
            if !p_at.end_time.blank?
              sum = p_at.end_time - p_at.start_time
            else 
              meeting = Meeting.where(sco_id: p_at.sco_id).first
              sum = meeting.end_time - p_at.start_time
            end
          end
          result << {utid: principal.uid, sum: sum}
        end
      end
    end
    return result
  end

end
