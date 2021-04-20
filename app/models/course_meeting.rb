class CourseMeeting < ApplicationRecord
  require "mechanize"
  require "nokogiri"
  require "open-uri"
  require "jalalidate"
  def self.get_meeting
    #p course_id
    #if !course_id.blank? && !module_id.blank? && !label.blank?
    agent = Mechanize.new

    # Get the flickr sign in page
    page = agent.get "https://elearn5.ut.ac.ir/login/index.php?authutcas=NOCAS"

    # Fill out the login form
    form = page.form_with :id => "login"
    form.username = ""
    form.password = ""
    form.submit

    modules = [28, 36, 37, 39]
    for course_module in CourseModule.where("module_id in (?) and course_id > 58474", modules)
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
      course_id = course_module.course_id
      module_id = course_module.mid
      if !course_id.blank? && !module_id.blank? && !label.blank?
        course = agent.get "https://elearn5.ut.ac.ir/mod/adobeconnect" + label.to_s + "/view.php?id=" + module_id.to_s rescue nil
        if !course.blank?
          doc = Nokogiri::HTML(course.body)
          table = doc.search("table")[0]
          if !table.blank?
            table.search("tr").drop(1).each do |tr|
              tds = tr.search("td")

              start_date_raw = tds[2].text.split(" ")[1]
              p tds[2].text.split(" ")[1]
              start_time_raw = tds[2].text.split(" ")[0]
              start_date = start_date_raw.split("/")
              start_time = start_time_raw.split(":")
              start_date_g = JalaliDate.new(start_date[0].to_i, start_date[1].to_i, start_date[2].to_i, start_time[0].to_i, start_time[1].to_i)
              p start_date_g
              start_time_g = Time.parse("#{start_date_g.to_g} #{start_time[0].to_i}:#{start_time[1].to_i}")
              p start_time_g

              end_date_raw = tds[3].text.split(" ")[1]
              p tds[3].text.split(" ")[1]
              end_time_raw = tds[3].text.split(" ")[0]
              end_date = end_date_raw.split("/")
              end_time = end_time_raw.split(":")
              end_date_g = JalaliDate.new(end_date[0].to_i, end_date[1].to_i, end_date[2].to_i, end_time[0].to_i, end_time[1].to_i)
              p end_date_g
              end_time_g = Time.parse("#{end_date_g.to_g} #{end_time[0].to_i}:#{end_time[1].to_i}")
              p end_time_g

              CourseMeeting.create(course_id: course_id, sco_id: "", start_time: start_time_g, end_time: end_time_g, duration: (end_time_g - start_time_g) / 60)
              #course_sessions << {"start" => start_time_g, "end" => end_time_g, "duration" => duration}
            end
          end
        end
      end
    end
  end
end
