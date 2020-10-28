class Faculty < ApplicationRecord

    def self.extract_section 
        for faculty in self.all
            if !faculty.serial.blank? && faculty.serial.to_s.length == 4
                faculty.section = faculty.serial.to_s[0..1].to_i
                faculty.save
            end
        end
    end

    def the_section
        if !self.section.blank?
            Section.find_by_mid(self.section)
        end
    end
end
