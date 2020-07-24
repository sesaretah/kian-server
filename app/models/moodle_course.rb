class MoodleCourse < ActiveRecord::Base
    require 'unicode_fixer'
    self.abstract_class = true
    establish_connection :external_moodle

    def self.import_course
        moodle_courses = MoodleCourse.connection.exec_query("select * from mdl_course")
        for moodle_course in moodle_courses
            course = Course.where(mid: moodle_course["id"]).first
            if course.blank?
                Course.create(mid: moodle_course["id"],title: UnicodeFixer.fix(moodle_course["fullname"]), serial: moodle_course["idnumber"])
            end
        end
    end

    def self.import_course_modules 
        moodle_course_modules  = MoodleCourse.connection.exec_query("select * from mdl_course_modules")
        for moodle_course_module in moodle_course_modules
            course_module = CourseModule.where(mid: moodle_course_module["id"]).first
            if course_module.blank?
                CourseModule.create(mid: moodle_course_module["id"],module_id: moodle_course_module["module"], course_id: moodle_course_module["course"])
            end
        end
    end

    def self.import_meeting 
        moodle_meetings  = MoodleCourse.connection.exec_query("select * from mdl_adobeconnect_recording_cache")
        for moodle_meeting in moodle_meetings
            meeting = Meeting.where(mid: moodle_meeting["id"]).first
            if meeting.blank? && moodle_meeting["starttime"].to_i > 138000000
                Meeting.create(mid: moodle_meeting["id"],course_module_id: moodle_meeting["cmid"], sco_id: moodle_meeting["scoid"], adobe_id: moodle_meeting["adobeconnectid"], start_time: DateTime.strptime(moodle_meeting["starttime"].to_s,'%s'), end_time: DateTime.strptime(moodle_meeting["endtime"].to_s,'%s'), duration: (moodle_meeting["endtime"].to_i - moodle_meeting["starttime"].to_i)/60 )
            end
        end
    end

    def self.set_faculty
        for course in Course.all
            if !course.serial.blank?  && !course.serial.from(4).blank?
                course.faculty_id = course.serial.from(4).to(3)
                course.save
            end
        end
    end

    def self.set_semster
        for course in Course.all
            if !course.serial.blank? && !course.serial.from(0).blank?
                course.semster = course.serial.from(0).to(3)
                course.save
            end
        end
    end

    def self.import_course_scos 
        course_scos = MoodleCourse.connection.exec_query("select course, meetingscoid from mdl_adobeconnect_meeting_groups inner join mdl_adobeconnect on mdl_adobeconnect.id = mdl_adobeconnect_meeting_groups.instanceid ")
        for course_sco in course_scos
            CourseSco.create(course_id: course_sco['course'], sco_id: course_sco['meetingscoid'])
        end
    end

    def self.import_course_teachers
       course_teachers =  MoodleCourse.connection.exec_query("SELECT c.id, u.firstname,u.lastname FROM mdl_course c JOIN mdl_context ct ON c.id = ct.instanceid JOIN mdl_role_assignments ra ON ra.contextid = ct.id JOIN mdl_user u ON u.id = ra.userid JOIN mdl_role r ON r.id = ra.roleid WHERE r.id in  (2,3) ")
        for course_teacher in course_teachers
            CourseTeacher.create(course_id: course_teacher['id'], fullname: "#{course_teacher['firstname']} #{course_teacher['lastname']}" )
        end
    end

    def self.import_profiles
        profiles =  MoodleCourse.connection.exec_query("select username, id, firstname, lastname from mdl_user")
         for profile in profiles
             MoodleProfile.create(mid: profile['id'], utid: profile["username"] ,fullname: "#{profile['firstname']} #{profile['lastname']}" )
         end
     end

    def self.construct_course_meeting
        for course_module in CourseModule.all
            meetings = course_module.meetings
            for meeting in meetings
                CourseMeeting.create(course_id: course_module.course_id, start_time: meeting.start_time, end_time: meeting.end_time, duration: meeting.duration)
            end
        end
    end

    def self.calculate_meeting_duration
        for course in Course.all
            meetings = CourseMeeting.where(course_id: course.mid)
            sum = 0
            for meeting in meetings
                sum += meeting.duration
            end
            MeetingDuration.create(course_id: course.mid, duration: sum)
        end
    end
end