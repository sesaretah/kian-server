class BbMeeting < ApplicationRecord

    def self.total_avarage_time(course)
        total = 0
        num = 0
        bbms = BbMeeting.where(course_id: course.id)
        for bbm in bbms
            total += bbm.duration.abs
            num += 1
        end
        num > 0 ? avarage = total/num : avarage = 0
        return {total: total, avarage: avarage}
    end
end
