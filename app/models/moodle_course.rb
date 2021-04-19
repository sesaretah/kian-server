class MoodleCourse < ActiveRecord::Base
  require "unicode_fixer"
  require "digest/sha1"
  require "active_support/core_ext/hash"

  self.abstract_class = true
  establish_connection :external_moodle

  def self.import_course
    last_mid = 0
    last_course = Course.all.order("mid desc").first
    last_mid = last_course.mid if !last_course.blank?
    moodle_courses = MoodleCourse.connection.exec_query("select * from mdl_course where id > #{last_mid}")
    for moodle_course in moodle_courses
      course = Course.where(mid: moodle_course["id"]).first
      if course.blank?
        Course.create(mid: moodle_course["id"], title: UnicodeFixer.fix(moodle_course["fullname"]), serial: moodle_course["idnumber"])
      end
    end
  end

  def self.import_course_modules(semster)
    last_mid = 0
    last_course_modue = CourseModule.all.order("mid desc").first
    last_mid = last_course_modue.mid if !last_course_modue.blank?
    moodle_course_modules = MoodleCourse.connection.exec_query("select * from mdl_course_modules where id > #{last_mid}")
    for moodle_course_module in moodle_course_modules
      course_module = CourseModule.where(mid: moodle_course_module["id"], semster: semster).first
      if course_module.blank?
        CourseModule.create(mid: moodle_course_module["id"], module_id: moodle_course_module["module"], course_id: moodle_course_module["course"], semster: semster)
      end
    end
  end

  def self.add_semster_to_course_modules(semster)
    for course_module in CourseModule.where("semster is null")
      course_module.semster = semster
      course_module.save
    end
  end

  def self.import_meeting(i)
    last = Meeting.where(module_index: i).order("id asc").last
    last.blank? ? last_id = 0 : last_id = last.mid
    i == 1 ? index = "" : index = i.to_s
    moodle_meetings = MoodleCourse.connection.exec_query("select * from mdl_adobeconnect#{index}_recording_cache where id > #{last_id}")
    for moodle_meeting in moodle_meetings
      p moodle_meeting["id"]
      p i
      course_module = CourseModule.find_by_mid(moodle_meeting["cmid"])
      meeting = Meeting.where(mid: moodle_meeting["id"], module_index: i).first
      if meeting.blank? && !course_module.blank?
        p "create meeting"
        Meeting.create(mid: moodle_meeting["id"], module_index: i, course_module_id: course_module.id, sco_id: moodle_meeting["scoid"], adobe_id: moodle_meeting["adobeconnectid"], start_time: DateTime.strptime(moodle_meeting["starttime"].to_s, "%s"), end_time: DateTime.strptime(moodle_meeting["endtime"].to_s, "%s"), duration: (moodle_meeting["endtime"].to_i - moodle_meeting["starttime"].to_i) / 60)
      end
    end
  end

  def self.import_meetings
    for i in 1..5
      self.import_meeting(i)
    end
  end

  def self.set_faculty
    for course in Course.where("faculty_id is null")
      if !course.serial.blank? && !course.serial.from(4).blank?
        course.faculty_id = course.serial.from(4).to(3)
        course.save
      end
    end
  end

  def self.set_semster
    for course in Course.where("semster is null")
      if !course.serial.blank? && !course.serial.from(0).blank?
        course.semster = course.serial.from(0).to(3)
        course.save
      end
    end
  end

  def self.import_course_scos(i)
    course_scos = MoodleCourse.connection.exec_query("select course, meetingscoid from mdl_adobeconnect_meeting_groups inner join mdl_adobeconnect on mdl_adobeconnect.id = mdl_adobeconnect_meeting_groups.instanceid ")
    for course_sco in course_scos
      CourseSco.create(course_id: course_sco["course"], sco_id: course_sco["meetingscoid"])
    end
  end

  def self.import_course_teachers
    course_teachers = MoodleCourse.connection.exec_query("SELECT c.id, u.firstname,u.lastname FROM mdl_course c JOIN mdl_context ct ON c.id = ct.instanceid JOIN mdl_role_assignments ra ON ra.contextid = ct.id JOIN mdl_user u ON u.id = ra.userid JOIN mdl_role r ON r.id = ra.roleid WHERE r.id in  (2,3) ")
    for course_teacher in course_teachers
      CourseTeacher.create(course_id: course_teacher["id"], fullname: "#{UnicodeFixer.fix(course_teacher["firstname"])} #{UnicodeFixer.fix(course_teacher["lastname"])}")
    end
  end

  def self.import_profiles
    last_mid = 0
    last_profile = MoodleProfile.all.order("mid desc").first
    last_mid = last_profile.mid if !last_profile.blank?
    profiles = MoodleCourse.connection.exec_query("select username, id, firstname, lastname from mdl_user where id > #{last_mid}")
    for profile in profiles
      prf = MoodleProfile.where(utid: profile["username"]).first
      if prf.blank?
        MoodleProfile.create(mid: profile["id"], utid: profile["username"], fullname: "#{UnicodeFixer.fix(profile["firstname"])} #{UnicodeFixer.fix(profile["lastname"])}")
      end
    end
  end

  def self.construct_course_meeting
    modules = [28, 36, 37, 39]
    for course_module in CourseModule.where("module_id in (?)", modules)
      #meetings = course_module.meetings
      #for meeting in meetings
      #    cmeeting = CourseMeeting.where(course_id: course_module.course_id, sco_id: meeting.sco_id).first
      #   if cmeeting.blank?
      case course_module.module_id
      when 28
        label = ""
      when 36
        label = "2"
      when 37
        label = "3"
      when 38
        label = "5"
      end
      CourseMeeting.get_meeting(course_module.course_id, course_module.mid, label)
      #   end
      #end
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

  def self.calculate_bb_meeting_duration
    for course in Course.all
      meetings = BbMeeting.where(course_id: course.mid)
      sum = 0
      for meeting in meetings
        sum += meeting.duration
      end
      BbMeetingDuration.create(course_id: course.mid, duration: sum)
    end
  end

  def self.import_bigbluebtn
    last_mid = 0
    last_bigbluebtn = BigBlue.all.order("mid desc").first
    last_mid = last_bigbluebtn.mid if !last_bigbluebtn.blank?
    big_blues = MoodleCourse.connection.exec_query("select * from mdl_bigbluebuttonbn_logs where meta = '{\"record\":true}' and id > #{last_mid}")
    for big_blue in big_blues
      bb = BigBlue.where(mid: big_blue["id"]).first
      if bb.blank?
        BigBlue.create(mid: big_blue["id"], module_id: big_blue["bigbluebuttonbnid"], course_id: big_blue["courseid"], meeting_id: big_blue["meetingid"], user_id: big_blue["userid"])
      end
    end
  end

  def self.import_bb_recordings
    for bb in BigBlue.connection.exec_query("SELECT distinct on (meeting_id) * FROM public.big_blues")
      cheksum_string = "getRecordingsmeetingID=" + bb["meeting_id"] + "f4c70b0793683eaf0cc8e4bc49147420f734cbc546c63b26ff5cc0412764ec49"
      cheksum = Digest::SHA1.hexdigest cheksum_string
      url = "http://webinar3.ut.ac.ir/bigbluebutton/api/getRecordings?meetingID=" + bb["meeting_id"] + "&checksum=" + cheksum
      p url
      response = HTTParty.get(url)
      body = Hash.from_xml(response.body)
      if body["response"]["recordings"] != "\n  "
        for r in body["response"]["recordings"]
          if r[1].kind_of?(Array)
            for rec in r[1]
              duration = rec["playback"]["format"]["length"]
              record_id = rec["recordID"]
              start_time = DateTime.strptime((rec["startTime"].to_i / 1000).to_i.to_s, "%s")
              number_of_participants = rec["participants"].to_i
              bbm = BbMeeting.where(record_id: record_id).first
              if bbm.blank?
                BbMeeting.create(course_id: bb["course_id"], duration: duration, record_id: record_id, start_time: start_time, number_of_participants: number_of_participants)
              end
            end
          else
            duration = r[1]["playback"]["format"]["length"]
            record_id = r[1]["recordID"]
            start_time = DateTime.strptime((r[1]["startTime"].to_i / 1000).to_i.to_s, "%s")
            number_of_participants = r[1]["participants"].to_i
            bbm = BbMeeting.where(record_id: record_id).first
            if bbm.blank?
              BbMeeting.create(course_id: bb["course_id"], duration: duration, record_id: record_id, start_time: start_time, number_of_participants: number_of_participants)
            end
          end
        end
      end
    end
  end

  def self.meeting_info
    #big_blues  = MoodleCourse.connection.exec_query("select distinct on (meetingid) * from mdl_bigbluebuttonbn")
    #for bb in big_blues
    # p bb['meetingid']
    cheksum_string = "getMeetings" + "f4c70b0793683eaf0cc8e4bc49147420f734cbc546c63b26ff5cc0412764ec49"
    cheksum = Digest::SHA1.hexdigest cheksum_string
    link = "http://webinar3.ut.ac.ir/bigbluebutton/api/getMeetings?checksum=" + cheksum
    #response = HTTParty.get('http://webinar3.ut.ac.ir/bigbluebutton/api/getMeetings?checksum=' + cheksum)
    #body = Hash.from_xml(response.body)
    p link
    #end
  end

  def self.prepare_semster(semster)
    p "Prepare Started"
    ApplicationRecord.connection.exec_query("TRUNCATE courses, course_modules, meetings RESTART IDENTITY")
    ApplicationRecord.connection.exec_query("TRUNCATE course_teachers, moodle_profiles, course_meetings, bb_meeting_durations, bb_meetings  RESTART IDENTITY")

    #CourseTeacher.destroy_all
    #MoodleProfile.destroy_all
    #CourseModule.destroy_all
    #CourseSco.destroy_all
    #Course.destroy_all
    #CourseMeeting.destroy_all
    #Meeting.destroy_all
    #BigBlue.destroy_all
    #BbMeetingDuration.destroy_all
    #BbMeeting.destroy_all

    p "Importing Courses"
    self.import_course
    self.set_faculty
    self.set_semster
    p "Importing Course Modules"
    self.import_course_modules(semster)
    self.add_semster_to_course_modules(semster)

    p "Importing Course Meetings"
    #self.import_meetings
    self.import_profiles
    self.import_course_teachers

    p "Constructing Course Meetings"
    self.construct_course_meeting
    self.calculate_meeting_duration

    p "Importing Big Blues"
    self.import_bigbluebtn
    p "Importing Big Blue Recordings"
    self.import_bb_recordings
    self.calculate_bb_meeting_duration
  end
end
