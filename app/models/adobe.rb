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

end