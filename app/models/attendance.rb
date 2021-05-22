class Attendance < ApplicationRecord
  require "rubygems"
  require "csv"
  require "mechanize"
  require "nokogiri"
  require "open-uri"
  require "jalalidate"

  after_save :update_principal
  before_save :check_unique
  before_save :update_duration
  before_create :check_duration

  def check_unique
    attendance = Attendance.where(sco_id: self.sco_id, principal_id: self.principal_id, start_time: self.start_time).first
    if !attendance.blank?
      attendance.duration += self.duration
      attendance.save
      return false
    else
      return true
    end
  end

  def check_duration
    p "$$$$$$$$$$$$"
    p self.end_time - self.start_time
    if (self.end_time - self.start_time) < 600
      return false
    end
  end

  def update_duration
    self.duration = self.end_time - self.start_time
  end

  def update_principal
    pr = Principal.where(principal_id: self.principal_id).first
    if pr.blank? && self.principal_id != 0
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
      agent = Mechanize.new
      page = agent.get "#{domain}/api/xml?action=login&login=itadmin&password=13Feb2021utec"
      h = Hash.from_xml(page.body)
      token = h["results"]["OWASP_CSRFTOKEN"]["token"]
      principal = agent.get "#{domain}/api/xml?action=principal-info&principal-id=#{self.principal_id}"
      h = Hash.from_xml(principal.body)
      p "#{domain}/api/xml?action=principal-info&principal-id=#{self.principal_id}"
      if !h.blank?
        login = h["results"]["principal"]["login"]
        name = h["results"]["principal"]["name"]
        Principal.create(name: name, principal_id: self.principal_id, uid: login)
      end
    end
  end
end
