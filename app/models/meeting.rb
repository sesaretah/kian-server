class Meeting < ApplicationRecord
    self.primary_key = 'mid'
    belongs_to :course_module
end
