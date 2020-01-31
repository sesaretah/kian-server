class V1::PostsController < ApplicationController

  def index
    #@friend_ids = Friendship.friend_ids(current_user)
    #posts = Post.where('user_id IN (?)', @friend_ids).order('created_at desc')
    posts = Post.all
    render json: { data: ActiveModel::SerializableResource.new(posts, user_id: current_user.id,  each_serializer: PostSerializer ).as_json, klass: 'Post' }, status: :ok
  end


  def show
    @post = Post.find(params[:id])
    render json: { data:  PostSerializer.new(@post, user_id: current_user.id).as_json, klass: 'Post'}, status: :ok
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      @post.share(params[:channel_id]) if !params[:channel_id].blank?
      render json: { data: PostSerializer.new(@post).as_json, klass: 'Post' }, status: :ok
    end
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(post_params)
      render json: { data: PostSerializer.new(@post, user_id: current_user.id).as_json, klass: 'Post' }, status: :ok
    else
      render json: { data: @post.errors.full_messages  }, status: :ok
    end
  end

  def destroy
    @post = Post.find(params[:id])
    if @post.destroy
      render json: { data: 'OK'}, status: :ok
    end
  end

  def post_params
    params.require(:post).permit!
  end
end