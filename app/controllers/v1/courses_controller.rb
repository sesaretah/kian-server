class V1::CoursesController < ApplicationController


  def index
    result = []
    courses = Course.where('serial like ?', '%399%').paginate(page: 1, per_page: 100)
    render json: { data: ActiveModel::SerializableResource.new(Course.viewable(courses, current_user),  each_serializer: CourseShowSerializer ).as_json, klass: 'Course' }, status: :ok
  end

  def search
    if !params[:q].blank? && params[:q].length > 2
      courses = Course.search params[:q], star: true, :max_matches => 1_000,  :per_page    => 1_000
      render json: { data: ActiveModel::SerializableResource.new(Course.viewable(courses, current_user),  each_serializer: CourseShowSerializer ).as_json, klass: 'Course' }, status: :ok
    else 
      render json: { data: [], klass: 'Course' }, status: :ok
    end
  end

  def faculty
    courses = Course.where(faculty_id: params[:faculty_id], semster: 3991)
    render json: { data: FacultySerializer.new(courses).as_json,  klass: 'Faculty' }, status: :ok
  end


  def faculties
    faculties = []
    Course.all.group_by(&:faculty_id).map do |faculty_id, courses|
      faculty  = Faculty.find_by_serial(faculty_id)
      !faculty.blank? ? name = faculty.fullname : name = ''
      faculties << {id: faculty_id, name: name} if !faculty_id.blank?
    end
    render json: { data: faculties.sort_by { |h| h[:id] }.as_json, klass: 'Faculty' }, status: :ok
  end

  def section
    
    section = Section.find(params[:section_id])
    if !section.blank? && Skope.is_able?(current_user, section)
      courses = Course.where('serial like ?', "3991#{section.mid}%")
      render json: { data: SectionSerializer.new(courses).as_json,  klass: 'Section' }, status: :ok
    end
  end

  def sections

    sections = Section.where('id in (?)', Skope.user_sections(current_user))
    render json: { data: sections.sort_by { |h| h[:title] }.as_json, klass: 'Section' }, status: :ok
  end

  def show
    @course = Course.find_by_mid(params[:id])
    if @course.blank?
      @course = Course.find_by_serial(params[:id])
    end
    if Skope.is_able?(current_user, @course.section)
      render json: { data: CourseSerializer.new(@course).as_json,  klass: 'Course' }, status: :ok
    else
      render json: { data: [],  klass: 'Course' }, status: :ok
    end
  end



  def course_params
    params.require(:course).permit!
  end
end
