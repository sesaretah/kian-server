class CourseModule < ApplicationRecord
    self.primary_key = 'mid'
    belongs_to :course
    has_many :meetings
end
