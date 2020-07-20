class CourseShowSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :title, :number_of_meetings

  def id
    object.mid
  end

  def number_of_meetings
    course_modules =  object.course_modules.where(module_id: 28).first
    return course_modules.meetings.count if !course_modules.blank?
  end
end
