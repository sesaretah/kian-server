class V1::CoursesController < ApplicationController
  require "logger"

  def index
    result = []
    courses = Course.where("serial like ?", "%399%").paginate(page: 1, per_page: 100)
    render json: { data: ActiveModel::SerializableResource.new(Course.viewable(courses, current_user), each_serializer: CourseShowSerializer).as_json, klass: "Course" }, status: :ok
  end

  def uuider
    course = Course.find_by_mid(params[:id])
    if !course.blank?
      render json: { uuid: course.uuid }, status: :ok
    else
      render json: {}, status: :ok
    end
  end

  def search
    if !params[:q].blank? && params[:q].length > 2
      courses = Course.search params[:q], star: true, :max_matches => 1_000, :per_page => 1_000
      render json: { data: ActiveModel::SerializableResource.new(Course.viewable(courses, current_user), each_serializer: CourseShowSerializer).as_json, klass: "Course" }, status: :ok
    else
      render json: { data: [], klass: "Course" }, status: :ok
    end
  end

  def faculty
    courses = Course.where(faculty_id: params[:faculty_id], semster: 3992)
    params[:start].blank? ? time_start = Time.at(1612965838) : time_start = Time.at(params[:start].to_i)
    params[:end].blank? ? time_end = Time.now : time_end = Time.at(params[:end].to_i)
    render json: { data: FacultySerializer.new(courses, scope: { time_start: time_start, time_end: time_end }).as_json, klass: "Faculty" }, status: :ok
  end

  def inactive
    courses = Course.where(faculty_id: params[:faculty_id], semster: 3992)
    render json: { data: InactiveSerializer.new(courses).as_json, klass: "Inactive" }, status: :ok
  end

  def faculties
    faculties = []
    Course.all.group_by(&:faculty_id).map do |faculty_id, courses|
      faculty = Faculty.find_by_serial(faculty_id)
      !faculty.blank? ? name = faculty.fullname : name = ""
      faculties << { id: faculty_id, name: name } if !faculty_id.blank?
    end
    render json: { data: faculties.sort_by { |h| h[:id] }.as_json, klass: "Faculty" }, status: :ok
  end

  def section
    section = Section.find(params[:section_id])
    params[:start].blank? ? time_start = Time.at(1612965838) : time_start = Time.at(params[:start].to_i)
    params[:end].blank? ? time_end = Time.now : time_end = Time.at(params[:end].to_i)
    if !section.blank? && Skope.is_able?(current_user, section)
      courses = Course.where("serial like ?", "3992#{section.mid}%")
      render json: { data: SectionSerializer.new(courses, scope: { time_start: time_start, time_end: time_end }).as_json, klass: "Section" }, status: :ok
    end
  end

  def sections
    sections = Section.where("id in (?)", Skope.user_sections(current_user))
    render json: { data: sections.sort_by { |h| h[:title] }.as_json, klass: "Section" }, status: :ok
  end

  def show
    @course = Course.find_by_uuid(params[:id])
    if @course.blank?
      @course = Course.find_by_mid(params[:id])
    end
    if @course.blank?
      @course = Course.find_by_serial(params[:id])
    end

    if (@course.uuid == params[:id]) || (!current_user.blank? && Skope.is_able?(current_user, @course.section))
      render json: { data: CourseSerializer.new(@course).as_json, klass: "Course" }, status: :ok
    else
      render json: { data: [], klass: "Course" }, status: :ok
    end
  end

  def course_params
    params.require(:course).permit!
  end
end
