class Course < ApplicationRecord
  self.primary_key = "mid"
  require "securerandom"
  require "csv"
  has_many :course_modules
  has_many :course_teachers

  def self.export_khaksar
    file = "#{Rails.root}/public/khaksar.csv"
    rows = ApplicationRecord.connection.exec_query("SELECT exams + exercises + session_durations + teacher_view + student_view + resources AS s, serial, fullname FROM public.course_percentiles join public.courses on  public.course_percentiles.course_id = public.courses.mid join public.course_teachers on  public.course_percentiles.course_id = public.course_teachers.course_id ORDER BY s desc LIMIT 10000").rows
    CSV.open(file, "w") do |writer|
      for row in rows
        writer << [row[0], row[1], row[2]]
      end
    end
  end

  def self.export_courses(sec)
    file = "#{Rails.root}/public/sections/#{sec.title}.csv"

    CSV.open(file, "w") do |writer|
      for course in Course.all
        if course.faculty_id.to_s[0..1] == sec.mid.to_s
          cms30 = CourseMeeting.where("course_id = ? and duration > ?", course.id, 30).count
          bms30 = BbMeeting.where("course_id = ? and duration > ?", course.id, 30).count
          cms = CourseMeeting.where("course_id = ? and duration > ?", course.id, 5).count
          bms = BbMeeting.where("course_id = ? and duration > ?", course.id, 5).count
          cmd = CourseMeeting.where(course_id: course.id).pluck(:duration).join(", ")
          bmd = BbMeeting.where(course_id: course.id).pluck(:duration).join(", ")
          links = CourseModule.where("course_id = ? and module_id = ?", course.mid, 20).count
          assignments = CourseModule.where("course_id = ? and module_id in (?)", course.mid, [1, 2]).count
          resources = CourseModule.where("course_id = ? and module_id in (?)", course.mid, [8, 17]).count
          teachers = CourseTeacher.where(course_id: course.id).pluck(:fullname).uniq.join(", ")
          faculty = course.faculty.fullname rescue nil
          section = course.section.title rescue nil

          teacher_ids = CourseTeacher.where(course_id: course.mid).pluck(:user_id).uniq
          teacher_views = MoodleCourse.connection.exec_query("select
                count(*)
            from mdl_logstore_standard_log
            where courseid = #{course.mid} and action = 'viewed' and target = 'course' and userid in (#{teacher_ids.join(",")})
          ").rows[0].join("") rescue 0

          writer << [course.serial, section, faculty, course.title, teachers, cms30, bms30, cms, bms, links, resources, teacher_views, assignments]
        end
      end
    end
  end

  def self.special_export(title)
    file = "#{Rails.root}/public/#{title}.csv"

    CSV.open(file, "w") do |writer|
      i = 1
      for course in Course.all
        if i > 14
          cms30 = CourseMeeting.where("course_id = ? and duration > ?", course.id, 3).count
          bms30 = BbMeeting.where("course_id = ? and duration > ?", course.id, 3).count
          cms = CourseMeeting.where("course_id = ? and duration > ?", course.id, 5).count
          bms = BbMeeting.where("course_id = ? and duration > ?", course.id, 5).count
          cmd = CourseMeeting.where(course_id: course.id).pluck(:duration).join(", ")
          bmd = BbMeeting.where(course_id: course.id).pluck(:duration).join(", ")
          links = CourseModule.where("course_id = ? and module_id = ?", course.mid, 20).count
          assignments = CourseModule.where("course_id = ? and module_id in (?)", course.mid, [1, 2]).count
          resources = CourseModule.where("course_id = ? and module_id in (?)", course.mid, [8, 17]).count
          teachers = CourseTeacher.where(course_id: course.id).pluck(:fullname).uniq.join(", ")

          all_count = Attendance.connection.exec_query("select asset_id from attendances where course_id = #{Course.last.id} and duration > 1000 group by asset_id").count
          writer << [course.serial, course.title, teachers, all_count, cms30, bms30, cms, bms, links, resources, assignments]
        end
        i += 1
      end
    end
  end

  def self.export_section
    for section in Section.all
      Course.export_courses(section)
    end
  end

  def self.set_uuid_for_all
    for course in self.all
      course.uuid = SecureRandom.hex(13)
      course.save
    end
  end

  def total_avarage_time
    total = 0
    num = 0
    modules = [28, 36, 37, 38, 39]
    meeting = []
    course_module_ids = self.course_modules.where("module_id in (?)", modules).pluck(:mid)
    sco_ids = Meeting.where("course_module_id in (?)", course_module_ids).pluck(:sco_id).uniq if !course_module_ids.blank?
    if !sco_ids.blank?
      for sco_id in sco_ids
        meeting = Meeting.where("sco_id = ?", sco_id).first
        total += meeting.duration.abs
        num += 1
      end
    end
    num > 0 ? avarage = total / num : avarage = 0
    return { total: total, avarage: avarage }
  end

  def faculty
    Faculty.where(serial: self.faculty_id).first
  end

  def section
    if !self.serial.blank?
      section_mid = self.serial[4, 2]
      section = Section.where(mid: section_mid).first
    end
    return section if !section.blank?
  end

  def self.viewable(courses, user)
    result = []
    for course in courses
      result << course if !course.section.blank? && Skope.is_able?(user, course.section)
    end
    return result
  end
end
