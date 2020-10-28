class SectionSerializer < ActiveModel::Serializer
  attributes :section_faculties, :section_assets, :id, :total_assets,:most_quiz, 
            :most_resource,  :most_assignment,   :most_online_course_count,
            :most_online_course_duration, :most_activity, :name, :most_bb_online_course_count,
            :most_bb_online_course_duration


  def id
    object.first.faculty.the_section.mid if object.first && object.first.faculty && object.first.faculty.the_section
  end

  def name 
    object.first.faculty.the_section.title if object.first && object.first.faculty && object.first.faculty.the_section
  end

  def section_faculties
    if object.first && object.first.faculty && object.first.faculty.the_section
      Faculty.where(section: object.first.faculty.the_section.mid)
    end
  end

  def section_assets
    CourseModule.where('module_id not in (?) and course_id in (?)', [35, 36, 37, 38, 39, 28,29,9, 12, 8, 4], object.pluck(:mid)).group('module_id').count
  end

  def total_assets 
    CourseModule.where('module_id not in (?) and course_id in (?)', [35, 36, 37, 38, 39, 28,29,9, 12, 8, 4], object.pluck(:mid)).count
  end

  def most_quiz
    result = []
    array = CourseModule.where('module_id = ? and course_id in (?)', 16 , object.pluck(:mid)).group('course_id').order("count(course_id) DESC").limit(20).pluck("course_id, count(course_id)")
    for item in array
      course = Course.find_by_mid(item[0])
      if !course.serial.blank?
        result << {id: course.id, serial: course.serial, count: item[1]}
      end
    end
    return result
  end


  def most_resource
    result = []
    array = CourseModule.where('module_id = ? and course_id in (?)', 17 , object.pluck(:mid)).group('course_id').order("count(course_id) DESC").limit(20).pluck("course_id, count(course_id)")
    for item in array
      course = Course.find_by_mid(item[0])
      if !course.serial.blank?
        result << {id: course.id, serial: course.serial, count: item[1]}
      end
    end
    return result
  end

  def most_assignment
    result = []
    array = CourseModule.where('module_id in (?) and course_id in (?)', [1,2] , object.pluck(:mid)).group('course_id').order("count(course_id) DESC").limit(20).pluck("course_id, count(course_id)")
    for item in array
      course = Course.find_by_mid(item[0])
      if !course.serial.blank?
        result << {id: course.id, serial: course.serial, count: item[1]}
      end
    end
    return result
  end

  def most_activity
    result = []
    array = CourseModule.where('module_id not in (?) and course_id in (?)', [28,29] , object.pluck(:mid)).group('course_id').order("count(course_id) DESC").limit(20).pluck("course_id, count(course_id)")
    for item in array
      course = Course.find_by_mid(item[0])
      if !course.serial.blank?
        result << {id: course.id, serial: course.serial, count: item[1]}
      end
    end
    return result
  end

  def most_online_course_count
    result = []
    array = CourseMeeting.where('course_id in (?)', object.pluck(:mid)).group('course_id').order("count(course_id) DESC").limit(20).pluck("course_id, count(course_id)")
    for item in array
      course = Course.find_by_mid(item[0])
      if !course.serial.blank?
        result << {id: course.id, serial: course.serial, count: item[1]}
      end
    end
    return result
  end
  


  def most_online_course_duration
    result = []
    array = MeetingDuration.where('course_id in (?)', object.pluck(:mid)).order('duration DESC').limit(20)
    for item in array
      course = Course.find_by_mid(item.course_id)
      if !course.serial.blank?
        result << {id: course.id, serial: course.serial, count: item.duration}
      end
    end
    return result
  end


  def most_bb_online_course_count
    result = []
    array = BbMeeting.where('course_id in (?)', object.pluck(:mid)).group('course_id').order("count(course_id) DESC").limit(20).pluck("course_id, count(course_id)")
    for item in array
      course = Course.find_by_mid(item[0])
      if !course.serial.blank?
        result << {id: course.id, serial: course.serial, count: item[1]}
      end
    end
    return result
  end

  def most_bb_online_course_duration
    result = []
    array = BbMeetingDuration.where('course_id in (?)', object.pluck(:mid)).order('duration DESC').limit(20)
    for item in array
      course = Course.find_by_mid(item.course_id)
      if !course.serial.blank?
        result << {id: course.id, serial: course.serial, count: item.duration}
      end
    end
    return result
  end


end


