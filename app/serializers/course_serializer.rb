class CourseSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :avarage, :number_of_meetings, :meetings

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

end
