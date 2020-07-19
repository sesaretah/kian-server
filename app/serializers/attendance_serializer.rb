class AttendanceSerializer < ActiveModel::Serializer
    include Rails.application.routes.url_helpers
    attributes :id, :name, :surename, :fullname, :bio,  :avatar, :last_login,  :experties
  
end
  