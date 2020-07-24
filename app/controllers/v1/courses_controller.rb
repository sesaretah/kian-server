class V1::CoursesController < ApplicationController


  def index
    courses = Course.where('serial like ?', '%398%').paginate(page: 1, per_page: 30)
    render json: { data: ActiveModel::SerializableResource.new(courses,  each_serializer: CourseShowSerializer ).as_json, klass: 'Course' }, status: :ok
  end

  def search
    if !params[:q].blank?
      courses = Course.search params[:q], star: true, with: {semster: 3982}
      render json: { data: ActiveModel::SerializableResource.new(courses,  each_serializer: CourseShowSerializer ).as_json, klass: 'Course' }, status: :ok
    else 
      render json: { data: [], klass: 'Course' }, status: :ok
    end
  end

  def faculty
    courses = Course.where(faculty_id: params[:faculty_id], semster: 3982)
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

  def show
    @course = Course.find_by_mid(params[:id])
    render json: { data: CourseSerializer.new(@course).as_json,  klass: 'Course' }, status: :ok
  end



  def course_params
    params.require(:course).permit!
  end
end
