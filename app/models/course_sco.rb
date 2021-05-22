class CourseSco < ApplicationRecord
  require "rubygems"
  require "csv"
  require "mechanize"
  require "nokogiri"
  require "open-uri"
  require "jalalidate"
  #CourseSco.where(course_id: 50688).first.get_report
  after_save :get_report

  def get_report
    agent = Mechanize.new
    sco_id = self.sco_id
    file_root = "#{Rails.root}/public/scos/#{self.course_id}/"
    system("mkdir #{file_root}")

    case self.module
    when ""
      domain = "http://vclas16.ut.ac.ir"
    when "2"
      domain = "http://vclas13.ut.ac.ir"
    when "3"
      domain = "http://vclas18.ut.ac.ir"
    when "4"
      domain = "http://vclas18.ut.ac.ir"
    when "5"
      domain = "http://vclas27.ut.ac.ir"
    when "6"
      domain = "http://vclas13.ut.ac.ir"
    end

    page = agent.get "#{domain}/api/xml?action=login&login=itadmin&password=13Feb2021utec"
    h = Hash.from_xml(page.body)
    token = h["results"]["OWASP_CSRFTOKEN"]["token"]
    sessions_csv = agent.get "#{domain}/admin/meeting/sco/reports/sco/sessions/csv?account-id=7&sco-id=#{sco_id}&sort-date-created=desc&tab-id=11003&OWASP_CSRFTOKEN=#{token}"
    puts sessions_csv.body
    File.open(file_root + "#{sco_id}.csv", "wb") do |file|
      file << sessions_csv.body
    end

    line_num = 0
    text = File.open(file_root + "#{sco_id}.csv", :encoding => "ISO-8859-1").read
    text.gsub!(/\r\n?/, "\n")
    text.each_line do |line|
      if line_num != 0
        s = line.encode("iso-8859-1").force_encoding("utf-8")
        l = s.split("\t")

        if !l[1].blank?
          asset_id = l[1].delete(" \t\r\n").gsub(%r{\u0000}, "")
          puts "#{domain}/admin/meeting/sco/reports/sco/sessions/meeting-session-users/csv?account-id=7&asset-id=#{asset_id}&sco-id=#{sco_id}&tab-id=11003&OWASP_CSRFTOKEN=#{token}"
          a = agent.get "#{domain}/admin/meeting/sco/reports/sco/sessions/meeting-session-users/csv?account-id=7&asset-id=#{asset_id}&sco-id=#{sco_id}&tab-id=11003&OWASP_CSRFTOKEN=#{token}"
          File.open(file_root + "#{asset_id}.csv", "wb") do |file|
            file << a.body
          end
          att_line_num = 0
          att = File.open(file_root + "#{asset_id}.csv", :encoding => "ISO-8859-1").read
          att.gsub!(/\r\n?/, "\n")
          att.each_line do |ln|
            if att_line_num != 0
              e = ln.encode("utf-8")
              ar = e.split("\t")
              if !ar[1].blank? && !ar[2].blank?
                principal_id = ar[1].delete(" \t\r\n").gsub(%r{\u0000}, "").to_i
                start_time = DateTime.parse(ar[2].gsub(" \t\n", " ").gsub(%r{\u0000}, ""))
                end_time = DateTime.parse(ar[3].gsub(" \t\n", " ").gsub(%r{\u0000}, ""))
                Attendance.create(asset_id: asset_id, sco_id: sco_id, principal_id: principal_id, start_time: start_time, end_time: end_time, course_id: self.course_id, module: self.module, duration: 0)
              end
            end
            att_line_num += 1
          end
        end
      end
      line_num += 1
    end
  end
end
