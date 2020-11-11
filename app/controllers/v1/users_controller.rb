class V1::UsersController < ApplicationController
  include JWTWrapper
  #def login
  #  if User.find_by_email(params['email']).try(:valid_password?, params[:password])
  #    @user = User.find_by_email(params['email'])
  #    render :json => {data: {result: 'OK', token: JWTWrapper.encode({ user_id: @user.id }), user_id: @user.id}, klass: 'User'}.to_json , :callback => params['callback']
  #  else
  #    render :json => {result: 'ERROR',  error: I18n.t(:doesnt_match) }.to_json , status: :unprocessable_entity
  #  end
  #end

  def login
      @user = User.find_by_email(params['email'])
      @user.notify_user if @user
      render :json => {data: {result: 'OK'}, klass: 'Login'}.to_json , :callback => params['callback']
  end

  def verify
    user = User.verify(params['verification_code'])
    if !user.blank?
      render :json => {data: {result: 'OK', token: JWTWrapper.encode({ user_id: user.id }), user_id: user.id}, klass: 'Verify'}.to_json , :callback => params['callback']
    else
      render :json => {result: 'ERROR',  error: I18n.t(:doesnt_match) }.to_json , status: :unprocessable_entity
    end
  end

  def sign_up
    if params['domains'].is_a? Integer
      domains = [params['domains'].to_i]
    else 
      domains = params['domains'].split(',')
    end
    @user = User.create(email: params['email'], password: params['password'], password_confirmation: params['password'], last_login: DateTime.now, domains: domains)
    render :json => {data: {result: 'OK'}, klass: 'SignUp'}.to_json , :callback => params['callback']
  end


 # def sign_up
 #   @user = User.new(email: params['email'], password: params['password'], password_confirmation: params['password_confirmation'])
 #   if @user.save
 #     Profile.create(name: params['name'], surename: params['surename'], user_id: @user.id)
 #     render :json => { data: {result: 'OK', token: JWTWrapper.encode({ user_id: @user.id }), user_id: @user.id}, klass: 'User'}.to_json, :callback => params['callback']
 #   else
 #     render :json => {result: 'ERROR', error: @user.errors }.to_json , status: :unprocessable_entity
 #   end
 # end

  def validate_token
    if !current_user.blank?
      render :json => {data: {result: 'OK', token: JWTWrapper.encode({ user_id: current_user.id }), user_id: current_user.id}, klass: 'Validate'}.to_json , :callback => params['callback']
    else 
      render json: { data:  [], klass: 'Error'}, status: :ok
    end
  end

  def index
    users = User.all
    render json: { data: ActiveModel::SerializableResource.new(users, user_id: current_user.id,  each_serializer: UserSerializer ).as_json, klass: 'User' }, status: :ok
  end

  def role
    if !current_user.blank?
      render json: { data:  AbilitySerializer.new(current_user).as_json, klass: 'UserRole'}, status: :ok
    end
  end


  def assignments
    user = User.find(params[:user_id])
    role = Role.find(params[:role_id])
    user.assign(role.id) if user && role
    render json: { data:  RoleSerializer.new(role, user_id: current_user.id).as_json, klass: 'Role'}, status: :ok
  end

  def delete_assignment
    user = User.find(params[:user_id])
    role = Role.find(params[:role_id])
    user.unassign(role.id) if user && role
    render json: { data:  RoleSerializer.new(role, user_id: current_user.id).as_json, klass: 'Role'}, status: :ok
  end

  def service
    response = open('https://auth.ut.ac.ir:8443/cas/serviceValidate?service=https%3A%2F%2Ftavan.ut.ac.ir%2Fusers%2Fservice&ticket='+params[:ticket]).read
    result = Hash.from_xml(response.gsub("\n", ""))
    Rails.logger.info result
  end

end
