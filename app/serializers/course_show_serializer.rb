class CourseShowSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :title

  def id
    object.mid
  end
end
