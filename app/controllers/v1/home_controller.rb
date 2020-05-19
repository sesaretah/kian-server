class V1::HomeController < ApplicationController


  def index
    params['order'] == 'title' ? tasks = Task.order_by_title_for_user(current_user)  : tasks = Task.order_by_deadline_for_user(current_user) 
    works = Work.newest_works(current_user)
    notifications = Notification.user_related(current_user, params[:page]).order('created_at DESC')
    reports = Report.user_reports(current_user)
    tv = Task.user_tasks(current_user)
    ev = Work.user_works(current_user)
    render json: { data: {tasks: jsoner(tasks, TaskIndexSerializer), works: jsoner(works, WorkIndexSerializer) , notifications: jsoner(notifications, NotificationSerializer), reports: jsoner(reports, ReportSerializer), tasks_visits: jsoner(tv, ActivitySerializer), events: jsoner(ev, WorkEventSerializer)}, klass: 'Home' }, status: :ok
  end


  def jsoner(hash, serializer)
    ActiveModel::SerializableResource.new(hash,  each_serializer: serializer, scope: {user_id: current_user.id} ).as_json
  end


end
