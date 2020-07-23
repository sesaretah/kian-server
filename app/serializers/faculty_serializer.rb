class FacultySerializer < ActiveModel::Serializer
  attributes :faculty_courses, :faculty_assets, :id, :total_assets,:most_quiz, :most_resource,:most_assignment

  def id
    object.first.faculty_id if object.first
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


end
