class Skope < ApplicationRecord

    def self.find_by_user(user)
        utid  = user.email.split('@')[0]
        return Skope.where(utid: utid).first
    end

    def self.is_able?(user, section)
        flag =  false
        skope = self.find_by_user(user)
        if !skope.blank?
           flag = true if skope.sections.includes?(section.id)
        end
        return flag
    end

    def self.user_sections(user)
        sections = []
        skope = self.find_by_user(user)
        sections << skope.sections if !skope.blank?
        return sections.flatten
    end
end
