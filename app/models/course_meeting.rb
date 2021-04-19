class CourseMeeting < ApplicationRecord
  def self.get_meeting(course_id, module_id,  label)
    agent = Mechanize.new

    # Get the flickr sign in page
    page  = agent.get 'https://elearn5.ut.ac.ir/login/index.php?authutcas=NOCAS'
    
    # Fill out the login form
    form          = page.form_with :id => 'login'
    form.username    = ''
    form.password = ''
    form.submit
    
    course = agent.get 'https://elearn5.ut.ac.ir/mod/adobeconnect'+label+'/view.php?id='+module_id
    doc = Nokogiri::HTML(course.body)
    table = doc.search('table')[0]
    table.search('tr').drop(1).each do |tr|
        tds = tr.search('td')
        if tds[4].text.include? 'ساعت'
          duration = tds[4].text.delete(' ').gsub!('ساعت',':').gsub!('دقیقه','').strip + ':00'
        else
          duration = '00:'+tds[4].text.delete(' ').gsub!('دقیقه',':').gsub!('ثانیه','')
        end
        start_date_raw = tds[2].text.split(' ')[1]
        start_time_raw = tds[2].text.split(' ')[0]
        start_date = start_date_raw.split('/')
        start_time = start_time_raw.split(':')
        start_date_g = JalaliDate.new(start_date[0].to_i,start_date[1].to_i,start_date[2].to_i, start_time[0].to_i, start_time[1].to_i)
        start_time_g = Time.parse("#{start_date_g.to_g} #{start_date_g.strftime('%X')}")
    
        end_date_raw = tds[2].text.split(' ')[1]
        end_time_raw = tds[2].text.split(' ')[0]
        end_date = end_date_raw.split('/')
        end_time = end_time_raw.split(':')
        end_time_g = JalaliDate.new(end_date[0].to_i,end_date[1].to_i,end_date[2].to_i, end_time[0].to_i, end_time[1].to_i)
        end_time_g = Time.parse("#{end_time_g.to_g} #{end_time_g.strftime('%X')}")
        
        CourseMeeting.create(course_id: course_id, sco_id: sco_id,start_time: start_time_g, end_time: end_time_g, duration: duration)
        #course_sessions << {"start" => start_time_g, "end" => end_time_g, "duration" => duration}
    end
  end
end
