class FacultySerializer < ActiveModel::Serializer
  attributes :faculty_courses, :faculty_assets, :id, :total_assets,:most_quiz, 
            :most_resource,  :most_assignment,   :most_online_course_count,
            :most_online_course_duration, :most_activity, :name


  def id
    object.first.faculty_id if object.first
  end

  def name 
    name = ''
    faculty = Faculty.find_by_serial(object.first.faculty_id) if object.first
    name = faculty.fullname if faculty && !faculty.blank?
    return name
  end

  def faculty_courses
    result = []
    for course in object.sort_by { |h| h[:title] }
      result << {title: course.title, id: course.mid}
    end
    return result
  end

  def faculty_assets
    CourseModule.where('module_id not in (?) and course_id in (?)', [28,29,9, 12, 8, 4], object.pluck(:mid)).group('module_id').count
  end

  def total_assets 
    CourseModule.where('module_id not in (?) and course_id in (?)', [28,29,9, 12, 8, 4], object.pluck(:mid)).count
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


end


#CourseModule.joins('inner join meetings on course_modules.id = meetings.course_module_id').where('course_id in (?)', [27847]).group('course_modules.id').order("count(course_module_id) DESC").limit(20).pluck("course_modules.id, count(course_module_id)")