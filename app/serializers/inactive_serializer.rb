class InactiveSerializer < ActiveModel::Serializer
  attributes :courses

  def courses
    courses = []
    for course in object
      if CourseModule.where(course_id: course.id).count <= 14 && CourseMeeting.where(course_id: course.id).count == 0 && BbMeeting.where(course_id: course.id).count == 0
        courses << course
      end
    end
    return courses
  end
end
