class Adobe < ActiveRecord::Base
    require 'unicode_fixer'
    self.abstract_class = true
    establish_connection :external_adobe

    def self.import_attendance
        adobe_attendances = Adobe.connection.exec_query("SELECT transcript_id, sco_id, principal_id,date_created, date_closed FROM adobe2.pps_transcripts")
        for adobe_attendance in adobe_attendances
            attendance = Attendance.where(transcript_id: adobe_attendance["transcript_id"]).first
            if attendance.blank?
                Attendance.create(principal_id: adobe_attendance["principal_id"], sco_id: adobe_attendance["sco_id"], transcript_id: adobe_attendance["transcript_id"], start_time: adobe_attendance["date_created"], end_time: adobe_attendance["date_closed"])
            end
        end
    end

    def self.import_principals
        adobe_principals = Adobe.connection.exec_query("SELECT principal_id, name, login FROM adobe2.pps_principals")
        for adobe_principal in adobe_principals
            principal = Principal.where(principal_id: adobe_principal["principal_id"]).first
            if principal.blank?
                Principal.create(principal_id: adobe_principal["principal_id"], uid: adobe_principal["login"], name: adobe_principal["name"])
            end
        end
    end

end