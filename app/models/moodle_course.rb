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
end