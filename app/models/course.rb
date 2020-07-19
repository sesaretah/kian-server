class Course < ApplicationRecord
    self.primary_key = 'mid'
    has_many :course_modules

end
