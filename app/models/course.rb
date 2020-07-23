class Course < ApplicationRecord
    self.primary_key = 'mid'
    has_many :course_modules

    def total_avarage_time 
        course_module_ids =  self.course_modules.where(module_id: 28).pluck(:mid)
        total = 0
        num = 0
        if !course_module_ids.blank?
            for meeting in Meeting.where('course_module_id in (?)', course_module_ids)
                total += meeting.duration.abs
                num += 1
            end
        end
         num > 0 ? avarage = total/num : avarage = 0
        return {total: total, avarage: avarage}
    end

end
