class Course < ApplicationRecord
    self.primary_key = 'mid'
    has_many :course_modules

    def total_avarage_time 
        total = 0
        num = 0
        modules = [28, 36, 37, 38, 39]
        meeting = []
        course_module_ids =  self.course_modules.where('module_id in (?)', modules).pluck(:mid)
        sco_ids = Meeting.where('course_module_id in (?)', course_module_ids).pluck(:sco_id).uniq if !course_module_ids.blank?
        if !sco_ids.blank?
          for sco_id in sco_ids
            meeting = Meeting.where('sco_id = ?', sco_id).first
            total += meeting.duration.abs
            num += 1
          end
        end
         num > 0 ? avarage = total/num : avarage = 0
        return {total: total, avarage: avarage}
    end

    def faculty
      Faculty.where(serial: self.faculty_id).first
    end

end
